---
title: "Améliorer l'architecture de ses projets"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---



# Structure des projets {#structure}

## Modularité

-   fonctions
-   modules

## Principes d'architecture

Comme `Git` est un pré-requis, tout projet présente un fichier `.gitignore`
(il est très important, surtout quand on manipule des données qui ne
devraient pas se retrouver sur `Github` ou `Gitlab`).

Les _output_ sont stockés dans un dossier séparé, de même que les _inputs_
(idéalement ils ne sont même pas stockés avec le code, nous reviendrons
sur la distinction code-stockage-exécution plus tard). Ne pas
oublier d'ajouter les dossiers ou extensions qui vont bien dans
le `.gitignore` pour ne pas les committer.

Idéalement, un projet utilise de l'intégration continue (voir partie XXX) : 

- si vous utilisez `Gitlab`, les instructions sont stockées dans
le fichier `gitlab-ci.yml`
- si vous utilisez `Github`, cela se passe dans le dossier `.github/workflows`



{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}


{{% /panel %}}

{{% panel name="R" %}}

La première recommandation (si ce n'est obligation) est de privilégier
les projets `RStudio`. Voici ce qu'en dit la 
[documentation collaborative `utilitR`](https://www.book.utilitr.org)

> Le principe d'un projet `RStudio` est de rassembler tous les éléments de contexte propres à ce projet : espace de travail, historique de commandes, variables d'environnement, options de `R`... Utiliser un projet `RStudio` présente donc de multiples avantages : 
> 
> * Il centralise l'ensemble des éléments d'un projet : codes, réglages, documentation, et sorties (articles, présentations) ;
> * Il facilite la compréhension du traitement pour les utilisateurs extérieurs et rend plus aisées les évolutions postérieures du projet ;
> * Il organise l'interaction entre les fichiers (plusieurs codes, rédaction de documents avec R markdown...) et avec les données ;
> * Il renforce la portabilité : le répertoire de travail par défaut d’un projet est le dossier où se situe le fichier `.Rproj`. Cela rend les scripts indépendants de l'arborescence de la machine. Ainsi, si vous avez un code `traitement.R` situé dans le même dossier que le fichier `.Rproj`, alors le chemin de ce code est `./traitement.R`, où que soit situé le dossier du projet.

Ensuite, il est important de privilégier les fonctions comme évoqué précédemment
afin d'avoir un fichier qui n'accumule pas 50 000 lignes de code 
pour l'ensemble du projet de données. Les fonctions sont stockés dans un 
ou plusieurs fichiers `R` (idéalement organisés de manière thématique en 
regroupant une ou plusieurs fonctions faisant des opérations proches). 
Supposons que le fichier qui les utilise s'appelle `main.R` [^1]
[^1]: Nous évoquerons plus tard le principe de `targets` qui permet d'avoir
un _pipeline_ de données plus fiable que cette méthode.

```
project
│   .gitignore    
│   .gitlab-ci.yml    
│   main.R   
│   README.md
│
└───input
│   │   source.csv
│
└───R
│   │   utils.R
│   │   figures.R
|   |   statsdesc.R
|   |   ...
│   
└───output
    │   superfigure.png
    │   agregat.csv
    |   ...

```


{{% /panel %}}
{{< /panelset >}}




### Séparation données/code/config/environnement d'exécution

### Modèles

-   input / traitement / output
-   domain-driven design (data, domain, application, presentation)

### Templates

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

-   Python : cookiescutter


{{% /panel %}}

{{% panel name="R" %}}

Dans l'ensemble, la structure d'un projet en `R` est une variation
sur le thème du projet `RStudio`. Ce qui en général
va distinguer les types différents projets est la présence
de fichiers à la racine ou dans un dossier `R/`

Il existe un certain nombre de _templates_ de projets. Ceux-ci
sont accessibles lorsqu'on créé un nouveau projet
via `File > New Project`:

![](/rstudio-templates.png)

- Les projets sous forme de 
packages permettent d'intégrer de manière cohérente un ensemble
de fonctions. Le package peut contenir exclusivement du code `R` 
ou du code `C++` (via `Rcpp`)
- Les projets sous forme de site web (`bookdown` pour la documentation,
`blogdown` pour des sites web plus généraux) gèrent la transformation
entre des fichiers sources `R Markdown` et un site web à l'arborescence 
cohérente. 
- Les projets `shiny` attendent une structure particulière pour gérer
l'interaction entre l'interface graphique et les calculs à effectuer
en réaction aux actions sur l'interface. Le _framework_ 
`golem` permet de formaliser
de manière plus propre les projets shiny

Le package `usethis` offre des fonctionalités pratiques pour enrichir 
un projet de nouvelles options
ou changer de type de projet en cours de route (par exemple basculer d'un
projet basique à un _package_). 

{{% /panel %}}
{{< /panelset >}}


## Packages

La meilleure façon d'assurer la reproductibilité d'un projet est
d'intégrer ses scripts dans une structure de _package_.
Un gros projet
de _data-science_ va ainsi dépendre d'un ou plusieurs _packages_, ce qui 

- assure une gestion cohérente des dépendances
- offre une certaine structure pour la documentation
- facilitera sa réutilisation (les utilisateurs peuvent n'être intéressés
que par une partie du projet)
- permettra des économies d'échelle (on peut réutiliser
l'un des packages pour un autre projet)
- facilite le debuggage (il est
plus facile d'identifier une erreur quand elle est dans un package)
- ...


### Gestion des dépendances

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

-   Python : cookiescutter


{{% /panel %}}

{{% panel name="R" %}}

Un projet utilise généralement un certain nombre de librairies 
externes. Dans le code, on utilise en général la syntaxe
`pkg::function` (syntaxe à préférer pour éviter toute ambiguité)
ou `library(pkg)`
puis `function`. Cependant, cela ne garantit pas que le code soit
fonctionnel: quelqu'un qui n'a pas installé les librairies en 
question se retrouvera avec une erreur. Il est donc nécessaire 
de lister les dépendances à installer si on désire
que le code tourne sans soucis. C'est le rôle du fichier `DESCRIPTION`

> The job of the `DESCRIPTION` file is to store important metadata
about your package.
> When you first start writing packages,
you’ll mostly use these metadata to record what packages are needed
to run your package.
> However, as time goes by, other aspects of the metadata file will
become useful to you,
such as revealing what your package does (via the Title and Description)
and whom to contact (you!) if there are any problems.
> 
> ...
>
> It’s the job of the DESCRIPTION to list the packages that
your package needs to work.
> R has a rich set of ways to describe different types of dependencies.
> A key point is whether a dependency is needed by regular users or is only
> needed for development tasks or optional functionality.
>
> Hadley Wickham et Jenny Brian, [_R Packages_](https://r-pkgs.org/description.html)

Le fichier `DESCRIPTION` a vocation à lister les dépendances nécessaires
à installer pour qu'un code soit fonctionnel. Initialement prévu pour
les _packages_, il est devenu plus courant de le trouver (à l'image
du `requirements` de `Python`).

En effet, quand
un projet comporte ce fichier, on peut installer l'ensemble des dépendances
listées dans le `DESCRIPTION` en une ligne, ce qui est bien pratique :

```r
devtools::install_deps()
```

Pour créer ce fichier, l'idéal est d'utiliser le package `usethis` qui
va initialiser ce fichier à partir d'un _template_:

```r
usethis::use_description(check_name = FALSE)
```

Dans ce fichier, les dépendances seront listées dans divers champs, en 
fonction du degré de dépendance du code à ces librairies (
pour simplifier, les _packages_ indispensables seront listés dans 
un champ `Imports`, ceux qui peuvent servir pour des éléments
annexes dans un champ `Suggests`)

```r
Imports:
    dplyr,
    tidyr
```

L'utilisateur qui fera `devtools::install_deps()` se retrouvera alors
à installer `dplyr` et `tidyr` s'il ne les a pas déjà. 


{{% /panel %}}
{{< /panelset >}}


### Documentation

### Logging

### Tests unitaires

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

-   Python : cookiescutter


{{% /panel %}}

{{% panel name="R" %}}

Le package [`testthat`](https://testthat.r-lib.org/) offre 
des fonctionalités très intéressantes pour les tests.
Le manuel [R Packages](https://r-pkgs.org/tests.html)
présente un certain nombre d'exemples.


{{% /panel %}}
{{< /panelset >}}

### Publication

Quand on débute, on est souvent timide et on désire ne rendre public
son code que lorsque celui-ci est propre. C'est une erreur classique:

{{< tweet 589068687669243905 >}}

Comme pour nettoyer un appartement, les petits gestes en continu
sont beaucoup plus efficace qu'un grand ménage de printemps.
Prendre l'habitude de mettre son code immédiatement sur `Github`
vous amènera à adopter de bons gestes. 

### Maintenance


L'objectif des conseils de ce cours est
de réduire le coût de la
maintenance à long terme en adoptant les structures
les plus légères, automatisées et 
réutilisables. 

Les notebooks Jupyter sont très pratiques pour tâtonner
et expérimenter. Cependant, ils présentent un certain
nombre d'inconvénients à long terme qui peuvent 
rendre impossible à maintenir le code écrit
avec dans un notebook:

- tous les objets (fonctions, classes et données)
sont définis et disponibles dans le même fichier.
Le moindre changement à une fonction nécessite de retrouver
l'emplacement dans le code, écrire et faire tourner à nouveau
une ou plusieurs cellules. 
- quand on tâtonne, on écrit du code dans des cellules. 
Dans un cahier, on utiliserait la marge mais cela n'existe
pas avec un notebook. On créé donc de nouvelles cellules, 
pas nécessairement dans l'ordre. Quand il est
nécessaire de faire tourner à nouveau le notebook, cela
provoque des erreurs difficile à debugger (il est nécessaire
de retrouver l'ordre logique du code, ce qui n'est pas
évident). 
- les notebooks incitent à faire des copier-coller de cellules
et modifier marginalement le code plutôt qu'à utiliser
des fonctions. 
- il est quasi-impossible d'avoir un versioning avec Git des notebooks
qui fonctionne. Les notebooks étant, en arrière plan, de gros fichiers
JSON, ils ressemblent plus à des données que des codes sources. Git ne
parvient pas à identifier les blocs de code qui ont changé
- passage en production des notebooks coûteux alors qu'un script bien
fait est beaucoup plus facile à passer en prod (voir suite cours)
- Jupyter manque d'extensions pour mettre en oeuvre les bonnes pratiques
(linters, etc.). VSCode au contraire est très bien 
- Risques de révélation de données confidentielles puisque les outputs
des blocs de code, par exemple les `head`, sont écrits en dur dans
le code source. 

Globalement, les notebooks sont un bon outil pour tâtonner ou pour
faire communiquer. Mais pour maintenir un projet à long terme, 
il vaut mieux privilégier les scripts. Les
recommandations de ce cours visent à rendre le plus léger possible
la maintenance à long terme de projets _data-science_ en favorisant
la reprise par d'autres (ou par soi dans le futur).



# Références

- [The Hitchhiker’s Guide to Python](https://docs.python-guide.org/#writing-great-python-code)
- [_tidyverse style guide_](https://style.tidyverse.org/googl)
- [_google style guide_](https://google.github.io/styleguide/Rguide.html)
- [Cours de Pierre-Antoine Champin](https://perso.liris.cnrs.fr/pierre-antoine.champin/enseignement/algo/cours/algo/bonnes_pratiques.html)
- [R Packages](https://r-pkgs.org/index.html) par Hadley Wickham and Jenny Bryan
- [La documentation collaborative `utilitR`](https://www.book.utilitr.org)
- [Project Oriented Workflow](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/)
- [Un post très complet sur les extensions VisualStudio](https://realpython.com/advanced-visual-studio-code-python/)
- ["Coding style, coding etiquette"](https://blog.r-hub.io/2022/03/21/code-style/)
