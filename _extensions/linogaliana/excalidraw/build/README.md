# Construction des fichiers vendorisés

Ce dossier produit `../vendor/` : le moteur d'export SVG d'Excalidraw, ses polices et svg-pan-zoom.

**Pourquoi vendoriser ?** Le site ne doit appeler aucun CDN au moment de la lecture. Les fichiers
sont figés dans le dépôt, donc reproductibles, et servis avec le site.

**Pourquoi des stubs ?** Excalidraw charge dynamiquement des modules inutiles pour l'export SVG
(mermaid, pica, polices CJK, locales). `build.mjs` remplace leurs imports par un module vide
pour ne pas les embarquer.

**Polices retenues :** Excalifont, Virgil, Cascadia, Liberation et ComicShanns. Xiaolai (13 Mo de CJK),
Assistant, Nunito et Lilita sont écartées.

**Reconstruire :**

    cd _extensions/linogaliana/excalidraw/build
    npm ci
    npm run build

`npm run build` supprime `../vendor/` puis le régénère entièrement. Les versions sont épinglées
dans `package.json` ; ne pas les modifier sans vérifier le rendu.

Node n'est nécessaire que pour reconstruire, pas pour rendre le site.
