# ensae-reproductibilite-website

<!-- badges: start -->
<!-- badges: end -->

Contenu pour reproduire le site web 
https://ensae-reproductibilite.netlify.app/

## Tester en local

Le site repose sur le _framework_ Hugo (thème
[Hugo Apéro](https://hugo-apero-docs.netlify.app/)) créé par
[Allison Hill](https://www.apreshill.com/). 

Le package `blogdown`, disponible avec `R`, est idéal pour 
tester en local la construction du site

Après avoir clôné le dépôt et récupéré le thème (sous-module `Git`)

```shell
git clone https://github.com/linogaliana/ensae-reproductibilite-website.git
git submodule update --init --recursive
```

il suffit d'utiliser les fonctionalités de `blogdown` (il est conseillé
de privilégier l'utilisation via `RStudio` pour bénéficier de la mise
à jour instantanée du contenu sur un serveur local) :

```r
# blogdown::install_hugo()
blogdown::serve_site()
```
