---
title: "Structuration et qualité du code"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---

> The code is read much more often than it is written.
>
> Guido Van Rossum [créateur de Python]

<br>

`Python` est un langage très lisible.
Avec un peu d’effort sur le nom des objets,
sur la gestion des dépendances et sur la structure du programme,
on peut très bien comprendre un script sans avoir besoin de l’exécuter.
C'est l'une des principales forces du langage `Python` qui permet ainsi
une acquisition rapide des bases.
`R`, dans sa version de base, est un langage un peu plus verbeux que
`Python`.
Cependant, les packages les plus utiles pour l'analyse de données (notamment
`dplyr` ou `data.table`) offrent une grammaire un peu plus transparente.

Il est important de proposer, parmi 
les multiples manières de résoudre un problème informatique, une solution
qui soit intelligible par d'autres personnes parlant le langage. 
C'est donc naturellement que des tentatives, plus ou moins
institutionnalisées, de définir des 
conventions ont émergé. 

La communauté `Python` a abouti à un certain nombre de normes,
dites `PEP` (_Python Enhancement Proposal_),
qui constituent un standard dans l’écosystème Python.
Les deux normes les plus connues sont la norme `PEP8` (code)
et la norme `PEP257` (documentation).

Dans l'univers `R`, la formalisation
a été moins organisée. Néanmoins, des standards ont émergé, à travers
un certain nombre de _style guides_ dont les plus connus
sont le
[_tidyverse style guide_](https://style.tidyverse.org/googl) et le
[_google style guide_](https://google.github.io/styleguide/Rguide.html).
Ces conventions ne sont pas immuables: les langages et leurs usages
évoluent, ce qui nécessite de mettre à jour les conventions. Cependant,
adopter dans la mesure de possible certains des réflexes préconisés par ces
conventions devrait améliorer la capacité à être compris par la communauté,
bénéficier d'apport de celle-ci pour adapter le code ou réduire la 
difficulté à faire évoluer un code. 

Les conventions vont au-delà de la syntaxe. Un certain nombre de standards
d'organisation d'un projet ont émergé. La structuration d'un projet
permet d'immédiatement identifier les éléments de code et les éléments
annexes (par exemple les dépendances à gérer, la documentation, etc.).
Un certain nombre d'assistants au développement de projet
(des packages d'_helpers_ et des extensions aux environnements
de développement comme `VisualStudio` ou `RStudio`) ont 
émergé pour gagner en productivité et faciliter le
lancement d'un projet. 

Les éléments suivants ne sont pas exhaustifs. Ils visent à pointer vers
quelles problématiques prioritaires en proposant quelques conseils. 
Ils sont complémentaires d'un
[guide des bonnes pratiques `utilitR`](https://www.pratiques.utilitr.org)
qui vise à présenter de manière plus formelle quelques recommendations.
Les onglets `Python` et `R` permettent de comparer, à chaque fois, 
les deux langages. Globalement, les recommandations divergent rarement, 
ces deux langages ayant une logique très proche. 

# Qualité du code

## Principes généraux


Les premières conventions à évoquer ont trait à la syntaxe du code et
ont les objectifs suivants:

1. [Améliorer la lisibilité](#lisibilite) ce qui est indispensable pour
rendre la démarche intelligible par d'autres mais aussi pour soi, lorsqu'on
reprend un code écrit il y a quelques temps
2. [Favoriser la concision](#concision) pour réduire le risque d'erreur
et rendre la démarche plus claire. 
3. Suivre les règles explicites ou les conventions d'un langage pour
[assurer le fonctionnement et la cohérence](#coherence) d'un code
4. [Limiter la redondance](#redondance) ce qui permet de simplifier
un code (paradigme du _don't repeat yourself_)
5. [Documenter un code](#documentation) ce qui facilite son acquisition
par d'autres (à condition de ne pas aller dans l'excès de documentation)


### Lisibilité  {#lisibilite}

Un code écrit avec des noms de variables et de fonctions explicites est autant,
voire plus, informatif que les commentaires qui l’accompagnent.
C’est pourquoi il est essentiel de respecter des conventions pour le
choix des noms des objets afin d’assurer la lisibilité des programmes.


{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

- Adopter les mêmes standards que la communauté pour les noms de package

```python
# bien
import numpy as np

# trompeur
import numpy as pd
```

{{% /panel %}}
{{% panel name="R" %}}

- Les fonctions de base `R` utilisent des points dans les noms de fonctions
(`contrib.url()` par exemple) ou les noms de classes (`data.frame`).
Il est mieux de réserver les points uniquement aux objets de classe `S3`
sous la forme `fonction.classe` (approche de programmation orientée objet).

- Privilégier le _snake case_, (écriture avec des *underscores*, par exemple `donnees_menages`)
au _CamelCase_
(écriture avec des majuscules en début de nouveau mot, par exemple `donneesMenages`)
(préconisation du [tidyverse style guide](https://style.tidyverse.org/syntax.html)).
Si vous préférez le _CamelCase_, utilisez-le systématiquement dans tout le script pour uniformiser le code.

- Ne pas utiliser `T` ou `F` pour nommer des variables**
(car en plus d'être rarement des noms explicites ce sont les abréviations des booléens `TRUE` et `FALSE`)

- Ne pas utiliser de noms qui sont déjà des fonctions de base `R` (`mean` par exemple).
Cela ne génère pas toujours d'erreur mais cela évite des erreurs difficilement détectables! Voici un exemple d'erreur difficile à détecter:

```{r exemple T}
# On commence avec équivalence TRUE et T
TRUE == T
2 == TRUE
# On crée une variable T à un moment (shortcut de TRUE)
T <- 2
# On a rompu l'équivalence entre T et TRUE
TRUE == T
2 == T
```

- Le `return` n'est pas obligatoire en `R` mais il peut être utile
d'expliciter l'objet retourné.
Le [tidyverse style guide](https://style.tidyverse.org/functions.html#return)
recommande de ne pas le faire, le
[Google style guide](https://google.github.io/styleguide/Rguide.html#use-explicit-returns)
recommande de toujours expliciter. Nous recommandons de toujours mettre un
`return`.

- Faire attention au type d'objet renvoyé par `R`. `R` ne propose pas de typage
fort, il est donc possible qu'une fonction renvoie des objets de nature
différente en fonction de conditions `if` (selon les cas une liste, un vecteur,
un dataframe, etc.). Cela peut amener à des surprises lorsqu'on utilise une 
telle fonction dans un code. Il est recommandé d'éviter ce comportement
en proposant des fonctions différentes si l'_output_ d'une fonction 
est de nature différente. 

- Privilégier la programmation orientée objet lorsqu'une fonction doit
s'adapter au type d'objet en entrée (par exemple aller chercher des
éléments différents pour un objet `lm` ou un objet `glm`)
{{% /panel %}}
{{< /panelset  >}}


### Concision  {#concision}

Comme une démonstration mathématique, un code intelligible 
doit viser la concision et la simplicité. Les codes très longs
sont souvent signes de répétitions et sont difficiles à débugger. 

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

{{% /panel %}}

{{% panel name="R" %}}

- Le code `R` base ci-dessous est très difficile à comprendre ;
- Le code `dplyr` est plus intelligible mais est encore relativement verbeux ;
- Le code `data.table` est plus concis, ce qui le rend plus clair (et plus
proche de la syntaxe SQL).

<table class='table' style = "width : 70%;">
<tr> <td>

**`Base R`**

</td> 
<td>

```r
aggregate(
  dt[dt[["x"]] > 3]$y,
  by = list(dt[dt[["x"]] > 3]$z),
  FUN = sum)
```

</td>
</tr>
<tr>
<td>

**`dplyr`**

</td> 
<td>

```r
dt %>%
  dplyr::filter(x > 3) %>%
  dplyr::group_by(z) %>%
  dplyr::summarise(sum(y))
```

</td>
</tr>
<tr>
<td>

**`data.table`**

</td> 
<td>

```r
dt[x > 3, sum(y), by = z]
```
</td>
</tr>
</table>

{{% /panel %}}
{{< /panelset >}}


### Cohérence interne {#coherence}

Lister les dépendances est important,
tant pour des raisons techniques (que le logiciel sache où aller
chercher des fonctions nécessaires pour avoir un code fonctionnel)
que pour des raisons conventionnelles (que les utilisateurs comprennent les
dépendances à s'installer pour être en mesure de réutiliser le code). 
Pour cette raison, il est de bonne pratique de lister les dépendances
de deux manières:

* en début de script, l'ensemble des fonctions issues de librairies externes
ou les packages à importer doivent être listés ;
* dans un fichier externe (voir la [partie structure](#structure) et le chapitre portabilité),
les dépendances à installer sont listées.


Un code reproductible doit pouvoir s'exécuter de manière linéaire.
S'il provoque une erreur, il est important de pouvoir identifier
l'instruction responsable pour pouvoir _debugger_.

Les scripts trop longs ne sont pas une bonne pratique. Il est préférable
de diviser l'ensemble des scripts exécutant une
chaîne de production en "monades"", c'est-à-dire en petites unités
cohérentes. Les fonctions sont un outil privilégié pour cela
(en plus de limiter la redondance, et d'être un outil privilégié
pour documenter un code).


### Limiter la redondance {#redondance}

-   utiliser des fonctions

### Documentation {#documentation}

Un code sans aucun commentaire est très difficile à s'approprier (y compris
pour la personne qui l'a rédigé et qui y revient quelques semaines plus tard).
Cependant, un code présentant trop de commentaires est également illisible et
reflète généralement un défaut de conception du code qui n'est pas assez
explicite. 

La documentation vise à présenter la démarche générale, éventuellement
à travers des exemples, mais aussi à expliciter certains éléments
du code (une opération qui n'est pas évidente, des arguments de fonction, etc.). 
La documentation se mélange donc aux instructions visant à être exécutées
mais s'en distingue. Ces principes sont hérités du paradigme de la 
_"programmation lettrée"_ (_Literate programming_) dont l'un des 
avocats était Donald Knuth. 


> "Je crois que le temps est venu pour une amélioration significative de la documentation des programmes, et que le meilleur moyen d'y arriver est de considérer les programmes comme des œuvres littéraires. D'où mon titre, « programmation lettrée .
>
> Nous devons changer notre attitude traditionnelle envers la construction des programmes : au lieu de considérer que notre tâche principale est de dire à un ordinateur ce qu'il doit faire, appliquons-nous plutôt à expliquer à des êtres humains ce que nous voulons que l'ordinateur fasse.
>
> Celui qui pratique la programmation lettrée peut être vu comme un essayiste, qui s'attache principalement à exposer son sujet dans un style visant à l'excellence. Tel un auteur, il choisit , avec soin, le dictionnaire à la main, les noms de ses variables et en explique la signification pour chacune d'elles. Il cherche donc à obtenir un programme compréhensible parce que ses concepts sont présentés dans le meilleur ordre possible. Pour cela, il utilise un mélange de méthodes formelles et informelles qui se complètent"
>
> Donald Knuth, _Literate Programming_ ([source](https://fr.wikipedia.org/wiki/Programmation_lettr%C3%A9e))

Cela peut amener à distinguer deux types de documentation:

1. Une documentation générale de type `Jupyter Notebook` ou `R Markdown` qui 
présente certes du code exécuté mais dont l'objet principal est de présenter
une démarche ou des résultats
2. Une documentation de la démarche plus proche du code dont l'un des 
exemples sont les _docstrings_ `Python` ou la documentation `Roxygen`

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

- PEP 8, PEP 257


{{% /panel %}}

{{% panel name="R" %}}

L'exemple suivant, issu du livre de référence
d'Hadley Wickham et Jenny Bryan _R Packages_ permet de mesurer
l'intérêt de la documentation standardisée (bien-sûr ici la
fonction est assez explicite mais cela permet de se concentrer
sur la documentation). 

Les balises `Roxygen` s'insèrent autour de la définition d'une
fonction. Elles permettent à la lecture du code source de bien
comprendre l'objectif de la fonction ainsi que ses inputs. On
a même ici des exemples qui permettent de tester la fonction.

```r
#' Add together two numbers
#' 
#' @param x A number.
#' @param y A number.
#' @return The sum of \code{x} and \code{y}.
#' @examples
#' add(1, 1)
#' add(10, 1)
add <- function(x, y) {
  x + y
}
```

Ceci est déjà explicite à la lecture du code source. Cependant,
un avantage de cette structuration imposée de la documentation est
qu'ensuite, si la fonction est introduite dans un _package_,
la documentation de la fonction, accessible via `?add` par
exemple, est automatiquement mise en forme:

![](https://d33wubrfki0l68.cloudfront.net/b97dc657a7e1c7030d1b8d188723fb10f5260474/3dc52/images/man-add.png)

{{% /panel %}}
{{< /panelset >}}



## Standards communautaires de code

Pour parler le même langage, un certain nombre de conventions ont
émergé dans les communautés `R` et `Python`. L'objectif ici 
n'est pas de lister ces conventions (une partie d'entre elles ayant
déjà été évoquées) mais pointer rapidement vers les principales
conventions. 
Dans le domaine, `Python` a crée un système un peu plus formel que
`R` mais globalement, la démarche est la même. 

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

- PEP 8, PEP 257


{{% /panel %}}

{{% panel name="R" %}}

Les incontournables sont :

- [_tidyverse style guide_](https://style.tidyverse.org/googl)
- [_google style guide_](https://google.github.io/styleguide/Rguide.html)
* [Le guide du développeur Ropensci](https://devguide.ropensci.org/index.html)

`Ropensci` a également lancé un appel à contribution pour proposer
un guide des bonnes pratiques adapté aux projets de données 
gouvernementaux
[sur Github](https://github.com/ropensci-org/community-calls/issues/26).
L'OCDE devrait également lancer un manuel sur le sujet dans les prochains
mois. 

{{% /panel %}}
{{< /panelset >}}

## Outils et méthodes pour améliorer un code

### Helpers

`Python` ou `R` étant l'outil de travail principal de milliers de 
_data-scientists_, un certain nombre d'outils ont vu le jour
pour réduire le temps nécessaire pour créer un projet ou disposer
d'un code fonctionnel. Ces outils permettent un gros gain de productivité,
réduisent le temps passé à effectuer des tâches rébarbatives et améliorent
la qualité d'un projet en offrant des diagnostics voire des correctifs
à des codes perfectibles. 

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}


{{% /panel %}}

{{% panel name="R" %}}

La première chose à faire est de privilégier
les projets RStudio (
[voir la présentation de ceux-ci dans la documentation `utilitR`](https://www.book.utilitr.org/rproject.html)
et les éléments présentés dans la partie sur la
[structuration des projets](#structure)).

Les packages suivants font partie de la palette du développeur: 

* [`usethis`](https://usethis.r-lib.org/): s'il fallait n'en retenir qu'un (ce
qui serait tout de même un peu dommage...). Le couteau-suisse de la création
et de la gestion des options d'un projet
* [`devtools`](https://github.com/r-lib/devtools): le meilleur ami de la
personne qui développe les packages. Le livre [R Packages](https://r-pkgs.org/index.html)
donne de nombreux exemples à son propos. 
* [`here`](https://here.r-lib.org/): pour en finir avec la galère des chemins
relatifs, des dossiers de travail, etc.
* [`Roxygen`](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html): 
le package dédié à la documentation des fonctions
* [`goodpractice`](https://github.com/MangoTheCat/goodpractice): des diagnostics
pratiques sur la qualité du code

Enfin, `RStudio` propose de nombreux _addins_ (extensions) bien pratiques.
La plupart sont installés avec des _packages_ de _helpers_, n'hésitez
pas à en tester quelques uns. 

{{% /panel %}}
{{< /panelset >}}

### Analyse de code

-   linters
-   formatters

Les _linters_ sont des outils qui permettent d'évaluer la qualité du 
code et son risque de provoquer une erreur (explicite ou silencieuse).
Voici quelques exemples de problèmes que peuvent rencontrer les 
`linters`:

* les variables sont utilisées mais n'existent pas (erreur)
* les variables inutilisées (inutiles)
* la mauvaise organisation du code (risque d'erreur)
* le non respect des bonnes pratiques d'écriture de code
* les erreurs de syntaxe (par exemple les coquilles)
    
La plupart des logiciels de développement embarquent des fonctionalités
de diagnostic (voire de suggestion de correctif). Il faut parfois
les paramétrer dans les options (ils sont désactivés pour ne pas
effrayer l'utilisateur avec des croix rouges partout)

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}


{{% /panel %}}

{{% panel name="R" %}}

Les packages de référence dans le 
domaine sont:

- [`lintr`](https://github.com/r-lib/lintr) pour les diagnostics ;  
- [`styler`](https://github.com/r-lib/styler) pour la modification
automatisée des fichiers suite au diagnostic.

`RStudio` propose des diagnostics mais ils ne sont pas activés
par défaut. Pour les activer, après avoir fait `Tools > Global Options` : 

1. Aller dans la partie `Code` à gauche
2. Dans les onglets en haut, cliquer sur `Diagnostics`
3. Ajouter quelques diagnostics (par défaut ceux-ci sont vraiment
trop peu nombreux)

![](/rstudio-diagnostics.png)

Même si vous ne développez pas de _packages_ ces diagnostics vous
permettront d'améliorer la qualité de vos codes. 

{{% /panel %}}
{{< /panelset >}}

### Relecture par un tiers / pair-programming

# Structure des projets {#structure}

## Modularité

-   fonctions
-   modules

## Principes d'architecture

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}


{{% /panel %}}

{{% panel name="R" %}}

> Le principe d'un projet `RStudio` est de rassembler tous les éléments de contexte propres à ce projet : espace de travail, historique de commandes, variables d'environnement, options de `R`... Utiliser un projet `RStudio` présente donc de multiples avantages : 
> 
> * Il centralise l'ensemble des éléments d'un projet : codes, réglages, documentation, et sorties (articles, présentations) ;
> * Il facilite la compréhension du traitement pour les utilisateurs extérieurs et rend plus aisées les évolutions postérieures du projet ;
> * Il organise l'interaction entre les fichiers (plusieurs codes, rédaction de documents avec R markdown...) et avec les données ;
> * Il renforce la portabilité : le répertoire de travail par défaut d’un projet est le dossier où se situe le fichier `.Rproj`. Cela rend les scripts indépendants de l'arborescence de la machine. Ainsi, si vous avez un code `traitement.R` situé dans le même dossier que le fichier `.Rproj`, alors le chemin de ce code est `./traitement.R`, où que soit situé le dossier du projet.


{{% /panel %}}
{{< /panelset >}}




### Séparation données/code/config/environnement d'exécution

### Modèles

-   input / traitement / output
-   domain-driven design (data, domain, application, presentation)

### Templates

-   R : RProjects
-   Python : cookiescutter

## Packages

### Gestion des dépendances

### Documentation

### Logging

### Tests unitaires

### Publication

### Maintenance

# Application

Sur un projet personnel, terminé ou en cours :

-   utiliser un linter pour améliorer la qualité du code au maximum (seuil ?)

-   modulariser le code

    -   réécrire le code sous forme de fonctions
    -   répartir les fonctions dans des modules thématiques
    -   écrire un script `main.py` qui permet de reproduire le projet

-   choisir une architecture cohérente de projet

-   faire du projet un package


# Références

- [The Hitchhiker’s Guide to Python](https://docs.python-guide.org/#writing-great-python-code)
- [_tidyverse style guide_](https://style.tidyverse.org/googl)
- [_google style guide_](https://google.github.io/styleguide/Rguide.html)
- [Cours de Pierre-Antoine Champin](https://perso.liris.cnrs.fr/pierre-antoine.champin/enseignement/algo/cours/algo/bonnes_pratiques.html)
- [R Packages](https://r-pkgs.org/index.html) par Hadley Wickham and Jenny Bryan
- [La documentation collaborative `utilitR`](https://www.book.utilitr.org)
