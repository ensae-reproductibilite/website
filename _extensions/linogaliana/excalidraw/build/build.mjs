// Construction des fichiers vendorisés de l'extension excalidraw.
//
// Pourquoi vendoriser ? Le site doit s'afficher sans appel à un CDN au moment
// de la lecture (et sans dépendance qui bouge sous nos pieds) : les fichiers
// produits ici sont copiés dans ../vendor/ et servis avec le site.
//
// Pourquoi des stubs ? Excalidraw charge dynamiquement de nombreux modules
// (mermaid, pica, polices CJK, locales...) dont l'export SVG n'a pas besoin.
// Plutôt que de les embarquer, on remplace leur import par un module vide.
//
// Pour reconstruire : cd _extensions/linogaliana/excalidraw/build && npm ci && npm run build
// Node n'est nécessaire que pour reconstruire, pas pour rendre le site.

import * as esbuild from "esbuild";
import { readFileSync, writeFileSync, readdirSync, mkdirSync, copyFileSync, rmSync, existsSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const vendor = resolve(here, "..", "vendor");
const excalidrawOut = join(vendor, "excalidraw");
const panZoomOut = join(vendor, "svg-pan-zoom");
const prodDir = join(here, "node_modules", "@excalidraw", "excalidraw", "dist", "prod");

// Familles de polices retenues : dossier source -> nom de famille CSS.
// Xiaolai (CJK, 13 Mo) n'est pas embarquée. Assistant (interface de l'éditeur) l'est, à part.
// Les locales fr-FR et en (et percentages) sont gardées pour l'éditeur, voir plus bas.
const FAMILIES = {
  Excalifont: "Excalifont",
  Virgil: "Virgil",
  Cascadia: "Cascadia",
  Liberation: "Liberation Sans",
  ComicShanns: "Comic Shanns",
};

// Stubs : imports dynamiques jamais exécutés. Les locales fr-FR et en, ainsi que
// percentages (utilisées par l'éditeur), sont conservées ; les autres locales sont stubées.
const KEEP_LOCALE = /\/locales\/(fr-FR|en|percentages)-[^/]*\.js$/;
const STUB = /^(@excalidraw\/mermaid-to-excalidraw|image-blob-reduce|pica|canvas-roundrect-polyfill)$|subset-(worker|shared)\.chunk\.js$|\/locales\/|\/data\/image-/;
const isStubbed = (path) => STUB.test(path) && !KEEP_LOCALE.test(path);
const stubPlugin = {
  name: "stub",
  setup(build) {
    build.onResolve({ filter: STUB }, (args) =>
      args.kind === "dynamic-import" && isStubbed(args.path) ? { path: "stub", namespace: "stub" } : null);
    build.onLoad({ filter: /.*/, namespace: "stub" }, () => ({ contents: "export default {};", loader: "js" }));
  },
};

function fail(msg) {
  console.error(`ERREUR build excalidraw : ${msg}`);
  process.exit(1);
}

// 1. Repart de zéro.
rmSync(vendor, { recursive: true, force: true });
mkdirSync(excalidrawOut, { recursive: true });

// 2. JavaScript : entry.js (exportToSvg) + chunks partagés.
await esbuild.build({
  entryPoints: { entry: join(here, "entry.js") },
  outdir: excalidrawOut,
  entryNames: "[name]",
  chunkNames: "chunk-[hash]",
  bundle: true,
  format: "esm",
  splitting: true,
  minify: true,
  target: "es2020",
  legalComments: "none",
  define: { "process.env.NODE_ENV": '"production"', "process.env.IS_PREACT": '"false"' },
  external: ["*.css"],
  plugins: [stubPlugin],
});
if (!existsSync(join(excalidrawOut, "entry.js"))) fail("entry.js non produit");

// 3. Polices : on lit les déclarations @font-face d'Excalidraw dans son bundle.
const fontDecl = new Map(); // nom de variable -> chemin relatif (./fonts/...)
const fontEntries = []; // { varName, unicodeRange }
const jsFiles = readdirSync(prodDir).filter((f) => f.endsWith(".js"));
for (const f of jsFiles) {
  const src = readFileSync(join(prodDir, f), "utf8");
  for (const m of src.matchAll(/var ([A-Za-z_$][\w$]*)="(\.\/fonts\/[^"]+\.woff2)"/g)) {
    fontDecl.set(m[1], m[2]);
  }
}
for (const f of jsFiles) {
  const src = readFileSync(join(prodDir, f), "utf8");
  const familyVars = [...fontDecl.keys()].filter((v) => FAMILIES[fontDecl.get(v).split("/")[2]]);
  // Entrées { uri: VAR } ou { uri: VAR, descriptors: { unicodeRange: "..." , ... } }
  const re = /\{uri:([A-Za-z_$][\w$]*)(?:,descriptors:\{unicodeRange:"([^"]*)"[^}]*\})?\}/g;
  const matched = new Set();
  for (const m of src.matchAll(re)) {
    fontEntries.push({ varName: m[1], unicodeRange: m[2] ?? null });
    matched.add(m[0]);
  }
  // Toute entrée d'une de nos familles doit avoir été reconnue (sinon regex à mettre à jour).
  for (const v of familyVars) {
    const occurrences = src.split(`{uri:${v}`).length - 1;
    const recognised = fontEntries.filter((e) => e.varName === v).length;
    if (occurrences !== recognised && !(occurrences === 0)) {
      fail(`entrée de police non reconnue pour la variable ${v} dans ${f}`);
    }
  }
}

const rules = {};
for (const fam of Object.keys(FAMILIES)) rules[fam] = [];
const usedFiles = new Map(); // chemin source -> chemin de sortie
for (const { varName, unicodeRange } of fontEntries) {
  if (!fontDecl.has(varName)) {
    // "local:" (police système) : pas de fichier, on ignore.
    continue;
  }
  const rel = fontDecl.get(varName); // ./fonts/<Dossier>/<fichier>.woff2
  const [, , folder, file] = rel.split("/");
  if (!FAMILIES[folder]) continue; // police non retenue
  rules[folder].push({ file, folder, unicodeRange });
  usedFiles.set(join(prodDir, rel), join(excalidrawOut, "fonts", folder, file));
}
for (const [fam, list] of Object.entries(rules)) {
  if (list.length === 0) fail(`aucune règle @font-face pour la famille ${fam}`);
}

for (const [src, dst] of usedFiles) {
  if (!existsSync(src)) fail(`fichier de police introuvable : ${src}`);
  mkdirSync(dirname(dst), { recursive: true });
  copyFileSync(src, dst);
}

// Assistant (police de l'interface de l'éditeur) : chargée par l'éditeur depuis
// EXCALIDRAW_ASSET_PATH, pas de règle @font-face dans le bundle : on copie les fichiers.
const assistantSrc = join(prodDir, "fonts", "Assistant");
if (!existsSync(assistantSrc)) fail(`police Assistant introuvable : ${assistantSrc}`);
const assistantOut = join(excalidrawOut, "fonts", "Assistant");
mkdirSync(assistantOut, { recursive: true });
for (const f of readdirSync(assistantSrc).filter((n) => n.endsWith(".woff2"))) {
  copyFileSync(join(assistantSrc, f), join(assistantOut, f));
}

const css = [];
css.push("/* Généré par build/build.mjs : ne pas éditer à la main. */");
for (const [folder, list] of Object.entries(rules)) {
  for (const { file, unicodeRange } of list) {
    const range = unicodeRange ? `\n  unicode-range: ${unicodeRange.split(",").map((r) => (r.startsWith("U+") ? r : `U+${r}`)).join(", ")};` : "";
    css.push(
      `@font-face {\n  font-family: "${FAMILIES[folder]}";\n  font-style: normal;\n  font-weight: 400;\n  font-display: swap;\n  src: url("fonts/${folder}/${file}") format("woff2");${range}\n}`
    );
  }
}
writeFileSync(join(excalidrawOut, "excalidraw-fonts.css"), css.join("\n") + "\n");

// 4. svg-pan-zoom : copie du UMD minifié (licence incluse dans l'en-tête).
const panZoomSrc = join(here, "node_modules", "svg-pan-zoom", "dist", "svg-pan-zoom.min.js");
if (!existsSync(panZoomSrc)) fail(`svg-pan-zoom introuvable : ${panZoomSrc}`);
mkdirSync(panZoomOut, { recursive: true });
copyFileSync(panZoomSrc, join(panZoomOut, "svg-pan-zoom.min.js"));

// 5. CSS de l'éditeur (interface), chargée à l'ouverture de l'éditeur.
const editorCss = join(here, "node_modules", "@excalidraw", "excalidraw", "dist", "prod", "index.css");
if (!existsSync(editorCss)) fail(`CSS de l'éditeur introuvable : ${editorCss}`);
copyFileSync(editorCss, join(excalidrawOut, "excalidraw.css"));

console.log("Build excalidraw terminé :", vendor);
