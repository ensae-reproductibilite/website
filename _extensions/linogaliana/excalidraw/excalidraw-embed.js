// Diagrammes Excalidraw interactifs côté navigateur.
// Chaque <span class="excalidraw-embed"> contient le JSON de la scène ; on le rend en SVG
// (exportToSvg, vendoré) puis on le rend navigable (svg-pan-zoom, vendoré). Rien n'est chargé
// tant qu'un diagramme n'approche pas de la zone visible.
// Mode édition : l'éditeur Excalidraw s'ouvre en plein écran, dans un calque ajouté à <body>
// (pas dans le diagramme : sur les diapositives reveal.js, le CSS d'échelle fausse les
// coordonnées du pointeur). Les modifications ne vivent qu'en mémoire : rien n'est enregistré.

const BASE = import.meta.url;
const ENTRY_URL = new URL("./vendor/excalidraw/entry.js", BASE).href;
const EDITOR_CSS_URL = new URL("./vendor/excalidraw/excalidraw.css", BASE).href;
const FONTS_URL = new URL("./vendor/excalidraw/excalidraw-fonts.css", BASE).href;
const ASSET_PATH = new URL("./vendor/excalidraw/", BASE).href;
const PANZOOM_URL = new URL("./vendor/svg-pan-zoom/svg-pan-zoom.min.js", BASE).href;

const EN = document.documentElement.lang.toLowerCase().startsWith("en");
const L = EN
  ? { zoomIn: "Zoom in", zoomOut: "Zoom out", recenter: "Recenter", fullscreen: "Fullscreen",
      exitFullscreen: "Exit fullscreen", download: "Download diagram", toolbar: "Diagram tools",
      edit: "Edit diagram", badge: "Edited · not saved", editorLabel: "Diagram editor",
      done: "Done", cancel: "Cancel", reset: "Reset", editorError: "The editor could not be loaded.",
      hint: "Ctrl + wheel to zoom", hintMac: "⌘ + wheel to zoom",
      error: "The diagram could not be displayed." }
  : { zoomIn: "Zoom avant", zoomOut: "Zoom arrière", recenter: "Recentrer", fullscreen: "Plein écran",
      exitFullscreen: "Quitter le plein écran", download: "Télécharger le schéma", toolbar: "Outils du schéma",
      edit: "Modifier le schéma", badge: "Modifié · non enregistré", editorLabel: "Éditeur du schéma",
      done: "Terminer", cancel: "Annuler", reset: "Réinitialiser", editorError: "L'éditeur n'a pas pu être chargé.",
      hint: "Ctrl + molette pour zoomer", hintMac: "⌘ + molette pour zoomer",
      error: "Le schéma n'a pas pu être affiché." };
const IS_MAC = /Mac|iPhone|iPad/.test(navigator.platform || navigator.userAgent);

// Chargements partagés : chaque ressource n'est demandée qu'une fois.
const once = {};
function loadOnce(key, fn) {
  return (once[key] ??= fn());
}

function loadFontsCss() {
  return loadOnce("fonts", () => new Promise(resolve => {
    const link = document.createElement("link");
    link.rel = "stylesheet";
    link.href = FONTS_URL;
    // Les polices ne doivent pas bloquer le rendu : on résout aussi en cas d'erreur.
    link.onload = link.onerror = () => resolve();
    document.head.append(link);
  }));
}

function loadPanZoom() {
  return loadOnce("panzoom", () => new Promise((resolve, reject) => {
    if (window.svgPanZoom) return resolve(window.svgPanZoom);
    const script = document.createElement("script");
    script.src = PANZOOM_URL;
    script.onload = () => resolve(window.svgPanZoom);
    script.onerror = () => reject(new Error("svg-pan-zoom introuvable"));
    document.head.append(script);
  }));
}

// Le bundle contient exportToSvg, l'éditeur Excalidraw, React (createRoot, createElement).
function loadExcalidraw() {
  return loadOnce("excalidraw", () => {
    // Lu par Excalidraw au moment de charger ses polices : doit précéder l'import.
    window.EXCALIDRAW_ASSET_PATH = ASSET_PATH;
    return Promise.all([
      loadFontsCss(),
      loadPanZoom(),
      import(ENTRY_URL),
    ]).then(([, , mod]) => mod);
  });
}

// CSS de l'éditeur : chargée une seule fois, seulement à la première ouverture de l'éditeur.
function loadEditorCss() {
  return loadOnce("editor-css", () => new Promise((resolve, reject) => {
    const link = document.createElement("link");
    link.rel = "stylesheet";
    link.href = EDITOR_CSS_URL;
    link.onload = () => resolve();
    link.onerror = () => reject(new Error("CSS de l'éditeur introuvable"));
    document.head.append(link);
  }));
}

const FULLSCREEN_ICON = '<svg viewBox="0 0 16 16" width="16" height="16" aria-hidden="true" focusable="false">'
  + '<path d="M2 6V2h4M10 2h4v4M14 10v4h-4M6 14H2v-4" fill="none" stroke="currentColor" stroke-width="2"/></svg>';
const EDIT_ICON = '<svg viewBox="0 0 16 16" width="16" height="16" aria-hidden="true" focusable="false">'
  + '<path d="M11 2.5l2.5 2.5L6 12.5 2.5 13.5 3.5 10z M9.5 4l2.5 2.5" fill="none" stroke="currentColor" '
  + 'stroke-width="1.5" stroke-linejoin="round"/></svg>';

// Crée un élément avec classe et contenu texte.
function el(tag, className, text) {
  const node = document.createElement(tag);
  if (className) node.className = className;
  if (text !== undefined) node.textContent = text;
  return node;
}

// Transforme l'élément <noscript> (dont le texte est du HTML) en <img> de repli.
function fallbackImage(root) {
  const ns = root.querySelector("noscript");
  if (!ns) return null;
  const tpl = document.createElement("template");
  tpl.innerHTML = ns.textContent;
  return tpl.content.querySelector("img");
}

const background = scene => scene.appState?.viewBackgroundColor ?? "#ffffff";

// Champs que Excalidraw renouvelle à chaque édition : ignorés dans la comparaison.
const VOLATILE_KEYS = ["version", "versionNonce", "updated"];
// Excalidraw ajoute des valeurs par défaut (null, false, []) à l'ouverture de l'éditeur :
// elles sont comparées comme absentes.
const emptyValue = v => (v === undefined || v === null || v === false || (Array.isArray(v) && v.length === 0)
  ? null : v);

// Vrai si les deux listes d'éléments sont identiques (même ordre, mêmes valeurs d'origine).
// Les champs ajoutés par l'éditeur ne comptent pas : une simple ouverture ne marque pas le schéma.
function sameElements(current = [], original = []) {
  if (current.length !== original.length) return false;
  return original.every((orig, i) => {
    const cur = current[i];
    if (cur.id !== orig.id) return false;
    return Object.keys(orig).every(k => VOLATILE_KEYS.includes(k)
      || JSON.stringify(emptyValue(orig[k])) === JSON.stringify(emptyValue(cur[k])));
  });
}

function isEdited(view) {
  return !sameElements(view.current.elements, view.original.elements)
    || background(view.current) !== background(view.original);
}

// Fichier .excalidraw de la scène donnée (format attendu par Excalidraw).
function sceneFileText(scene) {
  return JSON.stringify({
    type: "excalidraw",
    version: 2,
    source: location.href,
    elements: scene.elements,
    appState: { viewBackgroundColor: background(scene), gridSize: null },
    files: scene.files || {},
  }, null, 2);
}

function downloadText(text) {
  const url = URL.createObjectURL(new Blob([text], { type: "application/json" }));
  const a = el("a");
  a.href = url;
  a.download = "schema.excalidraw";
  document.body.append(a);
  a.click();
  a.remove();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
}

// Dessine la scène (SVG + svg-pan-zoom) dans le conteneur du diagramme.
// Remplace le SVG précédent et détruit son instance svg-pan-zoom.
async function drawScene(view, scene) {
  const svg = await view.lib.exportToSvg({
    elements: structuredClone(scene.elements || []),
    appState: { ...(scene.appState || {}), exportBackground: false, exportWithDarkMode: false },
    files: structuredClone(scene.files || {}),
    exportPadding: 24, // marge autour du schéma une fois recentré
    skipInliningFonts: true, // les polices viennent de excalidraw-fonts.css
  });
  svg.setAttribute("width", "100%");
  svg.setAttribute("height", "100%");

  view.pz?.destroy?.();
  view.pz = null;
  view.canvas.replaceChildren(svg);
  view.svg = svg;
  view.pz = window.svgPanZoom(svg, {
    panEnabled: true, zoomEnabled: true,
    mouseWheelZoomEnabled: false, dblClickZoomEnabled: false, controlIconsEnabled: false,
    fit: true, center: true, minZoom: 0.2, maxZoom: 10, zoomScaleSensitivity: 0.3,
  });
  recenter(view);
}

function recenter(view) {
  if (!view.pz) return;
  view.pz.resize();
  view.pz.fit();
  view.pz.center();
}

function updateBadge(view) {
  view.badge.hidden = !isEdited(view);
}

// Ouvre l'éditeur en plein écran, dans un calque ajouté à <body>.
async function openEditor(view) {
  if (view.editor) return;
  const pending = { pending: true };
  view.editor = pending;
  let lib;
  try {
    [lib] = await Promise.all([loadExcalidraw(), loadEditorCss()]);
  } catch (err) {
    console.error("Excalidraw : éditeur impossible à charger", err);
    if (view.editor === pending) view.editor = null;
    window.alert(L.editorError);
    return;
  }
  if (view.editor !== pending) return; // fermé pendant le chargement
  // Le calque est ajouté à <body> : il serait caché sous un diagramme en plein écran.
  if (document.fullscreenElement) await document.exitFullscreen().catch(() => {});

  const overlay = el("div", "excalidraw-editor");
  overlay.setAttribute("role", "dialog");
  overlay.setAttribute("aria-modal", "true");
  overlay.setAttribute("aria-label", L.editorLabel);
  const bar = el("div", "excalidraw-editor__bar");
  const button = (cls, label, onClick) => {
    const b = el("button", `excalidraw-editor__btn ${cls}`, label);
    b.type = "button";
    b.addEventListener("click", onClick);
    return b;
  };
  const done = button("excalidraw-editor__done", L.done, () => finishEditor(view));
  bar.append(
    done,
    button("excalidraw-editor__cancel", L.cancel, () => closeEditor(view)),
    button("excalidraw-editor__reset", L.reset, () => resetScene(view)),
    button("excalidraw-editor__download", L.download, () => {
      const api = view.editor?.api;
      if (api) downloadText(sceneFileText(sceneFromApi(api)));
    }),
  );
  const host = el("div", "excalidraw-editor__host");
  overlay.append(bar, host);

  // Les touches ne doivent pas atteindre reveal.js ni les raccourcis de la page.
  // Pas de preventDefault : la saisie dans l'éditeur doit fonctionner normalement.
  const stopKey = e => e.stopPropagation();
  const keyTypes = ["keydown", "keyup", "keypress"];
  for (const type of keyTypes) overlay.addEventListener(type, stopKey);

  const prevOverflow = document.body.style.overflow;
  document.body.style.overflow = "hidden";
  document.body.append(overlay);

  // Copie profonde : l'éditeur ne doit jamais modifier la scène d'origine.
  const copy = structuredClone({
    elements: view.current.elements || [],
    appState: view.current.appState || {},
    files: view.current.files || {},
  });
  const editor = { overlay, host, bar, keyTypes, stopKey, prevOverflow, api: null, root: null };
  view.editor = editor;
  editor.root = lib.createRoot(host);
  editor.root.render(lib.createElement(lib.Excalidraw, {
    initialData: {
      elements: copy.elements,
      appState: { ...copy.appState, viewBackgroundColor: copy.appState.viewBackgroundColor || "#ffffff" },
      files: copy.files,
      scrollToContent: true,
    },
    theme: document.body.classList.contains("quarto-dark") ? "dark" : "light",
    langCode: EN ? "en" : "fr-FR",
    excalidrawAPI: api => {
      if (view.editor === editor) editor.api = api;
    },
    UIOptions: { canvasActions: { loadScene: false, saveToActiveFile: false, export: false, saveAsImage: false } },
  }));
  done.focus();
}

// Scène courante de l'éditeur, lue en direct (élément conservé, fond seulement).
function sceneFromApi(api) {
  return {
    elements: structuredClone(api.getSceneElements()),
    appState: { viewBackgroundColor: api.getAppState().viewBackgroundColor },
    files: structuredClone(api.getFiles()),
  };
}

// Ferme l'éditeur sans rien modifier au diagramme, et rend le focus au bouton Modifier.
function closeEditor(view) {
  const ed = view.editor;
  if (!ed) return;
  view.editor = null;
  if (ed.pending) return; // éditeur pas encore monté : rien à démonter
  for (const type of ed.keyTypes) ed.overlay.removeEventListener(type, ed.stopKey);
  try {
    ed.root?.unmount();
  } catch (err) {
    console.warn("Excalidraw : démontage de l'éditeur", err);
  }
  ed.overlay.remove();
  document.body.style.overflow = ed.prevOverflow;
  view.editBtn?.focus();
}

// Terminer : la scène éditée devient la scène courante du diagramme.
async function finishEditor(view) {
  const ed = view.editor;
  if (!ed?.api) return closeEditor(view);
  const scene = sceneFromApi(ed.api);
  closeEditor(view);
  view.current = scene;
  try {
    await drawScene(view, scene);
  } catch (err) {
    console.error("Excalidraw : rendu de la scène modifiée impossible", err);
  }
  updateBadge(view);
}

// Réinitialiser : retour à la scène d'origine (le même JSON que dans la page).
async function resetScene(view) {
  const ed = view.editor;
  if (ed) {
    if (ed.api) {
      try {
        ed.api.updateScene({ elements: structuredClone(view.original.elements || []) });
      } catch (err) {
        console.warn("Excalidraw : remise à zéro de l'éditeur", err);
      }
    }
    closeEditor(view);
  }
  view.current = view.original;
  try {
    await drawScene(view, view.original);
  } catch (err) {
    console.error("Excalidraw : rendu de la scène d'origine impossible", err);
  }
  updateBadge(view);
}

async function render(root) {
  if (root.dataset.state) return; // rendu au plus une fois
  root.dataset.state = "loading";
  const fallback = fallbackImage(root);
  const view = { root, original: null, current: null, lib: null, pz: null, svg: null, editor: null };
  try {
    const raw = root.querySelector("script.excalidraw-data").textContent;
    const scene = JSON.parse(raw);
    view.original = scene;
    view.current = scene;
    view.lib = await loadExcalidraw();
    try {
      await document.fonts.load("20px Excalifont");
    } catch (err) {
      console.warn("Police Excalifont non chargée", err);
    }

    view.canvas = el("span", "excalidraw-embed__canvas");
    const hint = el("span", "excalidraw-embed__hint", IS_MAC ? L.hintMac : L.hint);
    hint.setAttribute("aria-hidden", "true");
    view.badge = el("span", "excalidraw-embed__badge", L.badge);
    view.badge.hidden = true;
    const toolbar = el("span", "excalidraw-embed__toolbar");
    toolbar.setAttribute("role", "toolbar");
    toolbar.setAttribute("aria-label", L.toolbar);
    const button = (cls, label, glyph, onClick) => {
      const b = el("button", `excalidraw-embed__btn ${cls}`);
      // Glyphe texte, ou icône SVG constante (plus fiable que certains caractères Unicode).
      if (glyph.startsWith("<")) b.innerHTML = glyph;
      else b.textContent = glyph;
      b.type = "button";
      b.setAttribute("aria-label", label);
      b.title = label;
      b.addEventListener("click", onClick);
      return b;
    };

    root.replaceChildren(view.canvas, toolbar, hint, view.badge);
    await drawScene(view, scene);
    updateBadge(view);

    const recenterThis = () => recenter(view);
    toolbar.append(
      button("excalidraw-embed__zoom-in", L.zoomIn, "+", () => view.pz?.zoomBy(1.25)),
      button("excalidraw-embed__zoom-out", L.zoomOut, "−", () => view.pz?.zoomBy(0.8)),
      button("excalidraw-embed__recenter", L.recenter, "⊙", recenterThis),
      button("excalidraw-embed__fullscreen", L.fullscreen, FULLSCREEN_ICON, () => {
        if (document.fullscreenElement === root) document.exitFullscreen();
        else root.requestFullscreen?.();
      }),
    );
    if (root.dataset.editable !== "false") {
      view.editBtn = button("excalidraw-embed__edit", L.edit, EDIT_ICON, () => openEditor(view));
      toolbar.append(view.editBtn);
    }
    toolbar.append(
      button("excalidraw-embed__download", L.download, "↓", () => downloadText(sceneFileText(view.current))),
    );
    // Le groupe contient des boutons : on ne garde pas role="img" qui les masquerait.
    root.setAttribute("role", "group");
    root.tabIndex = 0;

    // Zoom à la molette uniquement avec Ctrl/⌘ (pincement trackpad inclus) ; sinon la page défile.
    let hintTimer = null;
    view.canvas.addEventListener("wheel", e => {
      if (e.ctrlKey || e.metaKey) {
        e.preventDefault();
        const r = view.svg.getBoundingClientRect();
        const point = { x: e.clientX - r.left, y: e.clientY - r.top };
        view.pz?.zoomAtPointBy(Math.exp(-e.deltaY * 0.002), point);
      } else {
        hint.classList.add("is-visible");
        clearTimeout(hintTimer);
        hintTimer = setTimeout(() => hint.classList.remove("is-visible"), 1500);
      }
    }, { passive: false });
    view.canvas.addEventListener("dblclick", recenterThis);

    // Clavier : quand le diagramme lui-même a le focus.
    root.addEventListener("keydown", e => {
      if (e.target !== root) return;
      const keys = {
        "+": () => view.pz?.zoomBy(1.25), "=": () => view.pz?.zoomBy(1.25), "-": () => view.pz?.zoomBy(0.8),
        "0": recenterThis,
        ArrowLeft: () => view.pz?.panBy({ x: 50, y: 0 }), ArrowRight: () => view.pz?.panBy({ x: -50, y: 0 }),
        ArrowUp: () => view.pz?.panBy({ x: 0, y: 50 }), ArrowDown: () => view.pz?.panBy({ x: 0, y: -50 }),
      };
      const action = keys[e.key];
      if (action) { e.preventDefault(); action(); }
    });

    // Plein écran : seul le diagramme concerné est recentré, pas tous les autres.
    let wasFullscreen = false;
    document.addEventListener("fullscreenchange", () => {
      const isFullscreen = document.fullscreenElement === root;
      if (isFullscreen || wasFullscreen) recenterThis();
      wasFullscreen = isFullscreen;
    });
    // Redimensionnement : seul un changement de largeur recentre. Sur mobile, masquer la
    // barre d'adresse déclenche un resize pendant le défilement, ce qui réinitialisait le zoom.
    let resizeTimer = null;
    let lastWidth = null;
    new ResizeObserver(entries => {
      const width = entries[0].contentRect.width;
      if (lastWidth !== null && width !== lastWidth) {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(recenterThis, 200);
      }
      lastWidth = width;
    }).observe(root);

    root.dataset.state = "done";
  } catch (err) {
    console.error("Excalidraw : rendu impossible", err);
    view.pz?.destroy?.();
    root.removeAttribute("role");
    root.removeAttribute("tabindex");
    if (fallback) {
      root.replaceChildren(fallback);
    } else {
      root.replaceChildren(el("span", "excalidraw-embed__error", L.error));
    }
    root.dataset.state = "error";
  }
}

const embeds = document.querySelectorAll(".excalidraw-embed");
if ("IntersectionObserver" in window) {
  const io = new IntersectionObserver(entries => {
    for (const entry of entries) {
      if (!entry.isIntersecting) continue;
      io.unobserve(entry.target);
      render(entry.target);
    }
  }, { rootMargin: "300px" });
  embeds.forEach(e => io.observe(e));
} else {
  embeds.forEach(e => render(e));
}
