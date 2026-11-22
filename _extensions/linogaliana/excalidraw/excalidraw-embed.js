// Diagrammes Excalidraw interactifs côté navigateur.
// Chaque <span class="excalidraw-embed"> contient le JSON de la scène ; on le rend en SVG
// (exportToSvg, vendoré) puis on le rend navigable (svg-pan-zoom, vendoré). Rien n'est chargé
// tant qu'un diagramme n'approche pas de la zone visible.

const BASE = import.meta.url;
const ENTRY_URL = new URL("./vendor/excalidraw/entry.js", BASE).href;
const FONTS_URL = new URL("./vendor/excalidraw/excalidraw-fonts.css", BASE).href;
const PANZOOM_URL = new URL("./vendor/svg-pan-zoom/svg-pan-zoom.min.js", BASE).href;

const EN = document.documentElement.lang.toLowerCase().startsWith("en");
const L = EN
  ? { zoomIn: "Zoom in", zoomOut: "Zoom out", recenter: "Recenter", fullscreen: "Fullscreen",
      exitFullscreen: "Exit fullscreen", download: "Download diagram", toolbar: "Diagram tools",
      hint: "Ctrl + wheel to zoom", hintMac: "⌘ + wheel to zoom",
      error: "The diagram could not be displayed." }
  : { zoomIn: "Zoom avant", zoomOut: "Zoom arrière", recenter: "Recentrer", fullscreen: "Plein écran",
      exitFullscreen: "Quitter le plein écran", download: "Télécharger le schéma", toolbar: "Outils du schéma",
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

function loadExcalidraw() {
  return loadOnce("excalidraw", () => Promise.all([
    loadFontsCss(),
    loadPanZoom(),
    import(ENTRY_URL),
  ]).then(([, , mod]) => mod));
}

const FULLSCREEN_ICON = '<svg viewBox="0 0 16 16" width="16" height="16" aria-hidden="true" focusable="false">'
  + '<path d="M2 6V2h4M10 2h4v4M14 10v4h-4M6 14H2v-4" fill="none" stroke="currentColor" stroke-width="2"/></svg>';

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

async function render(root) {
  if (root.dataset.state) return; // rendu au plus une fois
  root.dataset.state = "loading";
  const fallback = fallbackImage(root);
  let pz = null;
  try {
    const raw = root.querySelector("script.excalidraw-data").textContent;
    const scene = JSON.parse(raw);
    const { exportToSvg } = await loadExcalidraw();
    try {
      await document.fonts.load("20px Excalifont");
    } catch (err) {
      console.warn("Police Excalifont non chargée", err);
    }
    const svg = await exportToSvg({
      elements: scene.elements,
      appState: { ...(scene.appState || {}), exportBackground: false, exportWithDarkMode: false },
      files: scene.files || {},
      skipInliningFonts: true, // les polices viennent de excalidraw-fonts.css
    });
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "100%");

    const canvas = el("span", "excalidraw-embed__canvas");
    canvas.append(svg);
    const hint = el("span", "excalidraw-embed__hint", IS_MAC ? L.hintMac : L.hint);
    hint.setAttribute("aria-hidden", "true");
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

    root.replaceChildren(canvas, toolbar, hint);
    pz = window.svgPanZoom(svg, {
      panEnabled: true, zoomEnabled: true,
      mouseWheelZoomEnabled: false, dblClickZoomEnabled: false, controlIconsEnabled: false,
      fit: true, center: true, minZoom: 0.2, maxZoom: 10, zoomScaleSensitivity: 0.3,
    });

    const recenter = () => { pz.resize(); pz.fit(); pz.center(); };
    toolbar.append(
      button("excalidraw-embed__zoom-in", L.zoomIn, "+", () => pz.zoomBy(1.25)),
      button("excalidraw-embed__zoom-out", L.zoomOut, "−", () => pz.zoomBy(0.8)),
      button("excalidraw-embed__recenter", L.recenter, "⊙", recenter),
      button("excalidraw-embed__fullscreen", L.fullscreen, FULLSCREEN_ICON, () => {
        if (document.fullscreenElement === root) document.exitFullscreen();
        else root.requestFullscreen?.();
      }),
      button("excalidraw-embed__download", L.download, "↓", () => {
        const url = URL.createObjectURL(new Blob([raw], { type: "application/json" }));
        const a = el("a");
        a.href = url;
        a.download = "schema.excalidraw";
        document.body.append(a);
        a.click();
        a.remove();
        setTimeout(() => URL.revokeObjectURL(url), 1000);
      }),
    );
    // Le groupe contient des boutons : on ne garde pas role="img" qui les masquerait.
    root.setAttribute("role", "group");
    root.tabIndex = 0;

    // Zoom à la molette uniquement avec Ctrl/⌘ (pincement trackpad inclus) ; sinon la page défile.
    let hintTimer = null;
    canvas.addEventListener("wheel", e => {
      if (e.ctrlKey || e.metaKey) {
        e.preventDefault();
        const r = svg.getBoundingClientRect();
        const point = { x: e.clientX - r.left, y: e.clientY - r.top };
        pz.zoomAtPointBy(Math.exp(-e.deltaY * 0.002), point);
      } else {
        hint.classList.add("is-visible");
        clearTimeout(hintTimer);
        hintTimer = setTimeout(() => hint.classList.remove("is-visible"), 1500);
      }
    }, { passive: false });
    canvas.addEventListener("dblclick", recenter);

    // Clavier : quand le diagramme lui-même a le focus.
    root.addEventListener("keydown", e => {
      if (e.target !== root) return;
      const keys = {
        "+": () => pz.zoomBy(1.25), "=": () => pz.zoomBy(1.25), "-": () => pz.zoomBy(0.8),
        "0": recenter,
        ArrowLeft: () => pz.panBy({ x: 50, y: 0 }), ArrowRight: () => pz.panBy({ x: -50, y: 0 }),
        ArrowUp: () => pz.panBy({ x: 0, y: 50 }), ArrowDown: () => pz.panBy({ x: 0, y: -50 }),
      };
      const action = keys[e.key];
      if (action) { e.preventDefault(); action(); }
    });

    // Plein écran : seul le diagramme concerné est recentré, pas tous les autres.
    let wasFullscreen = false;
    document.addEventListener("fullscreenchange", () => {
      const isFullscreen = document.fullscreenElement === root;
      if (isFullscreen || wasFullscreen) recenter();
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
        resizeTimer = setTimeout(recenter, 200);
      }
      lastWidth = width;
    }).observe(root);

    root.dataset.state = "done";
  } catch (err) {
    console.error("Excalidraw : rendu impossible", err);
    if (pz) pz.destroy?.();
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
