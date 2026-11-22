// Point d'entrée du bundle vendorisé : export SVG (affichage) et éditeur (mode édition).
// React est bundlé une seule fois, avec l'éditeur ; le site n'a pas d'autre copie.
export { exportToSvg, Excalidraw } from "@excalidraw/excalidraw";
export { createRoot } from "react-dom/client";
export { createElement } from "react";
