# Construction des fichiers vendorisés

Ce dossier produit `../vendor/` : le moteur d'export SVG d'Excalidraw, l'éditeur (mode édition
temporaire), ses polices et svg-pan-zoom.

`entry.js` exporte `exportToSvg` (affichage), `Excalidraw` (éditeur), `createRoot` et `createElement`
(React, bundlé une seule fois avec l'éditeur). `excalidraw.css` est la feuille de style de l'éditeur,
chargée seulement à sa première ouverture.

**Pourquoi vendoriser ?** Le site ne doit appeler aucun CDN au moment de la lecture. Les fichiers
sont figés dans le dépôt, donc reproductibles, et servis avec le site.

**Pourquoi des stubs ?** Excalidraw charge dynamiquement des modules inutiles pour l'export SVG
(mermaid, pica, polices CJK, locales). `build.mjs` remplace leurs imports par un module vide
pour ne pas les embarquer.

**Polices retenues :** Excalifont, Virgil, Cascadia, Liberation et ComicShanns, plus Assistant (interface
de l'éditeur). Xiaolai (13 Mo de CJK), Nunito et Lilita sont écartées.

**Locales :** l'éditeur a besoin des locales fr-FR, en et percentages ; les autres sont remplacées par des stubs.

**Reconstruire :**

    cd _extensions/linogaliana/excalidraw/build
    npm ci
    npm run build

`npm run build` supprime `../vendor/` puis le régénère entièrement. Les versions sont épinglées
dans `package.json` ; ne pas les modifier sans vérifier le rendu.

Node n'est nécessaire que pour reconstruire, pas pour rendre le site.
