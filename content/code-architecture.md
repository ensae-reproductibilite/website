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

-   expressivité des nommages

### Concision  {#concision}

-   simplicité


### Cohérence interne {#coherence}

-   importance des conventions, par projet et/ou communautaires

### Limiter la redondance {#redondance}

-   utiliser des fonctions

### Documentation {#documentation}

-   commentaires
-   docstrings

## Standards communautaires de code

-   R : tidyverse / Google style guides
-   Python : PEP 8, PEP 257

## Outils

### Analyse de code

-   linters
-   formatters

### Relecture par un tiers / pair-programming

# Structure des projets

## Modularité

-   fonctions
-   modules

## Principes d'architecture

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
