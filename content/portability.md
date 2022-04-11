---
title: "Rendre son projet de data science portable et reproductible"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---


# La notion de portabilité

Dans les chapitres précédents, nous avons vu un ensemble de bonnes pratiques qui permettent de considérablement améliorer la qualité d'un projet : rendre le code plus lisible, adopter une structure du projet normalisée et évolutive, et versionner proprement son code sur un dépôt GitHub.

Une fois ces bonnes pratiques appliquées à notre projet, ce dernier apparaît largement partageable. Du moins en théorie, car la pratique est souvent plus compliquée : il y a fort à parier que si vous essayez d'exécuter votre projet sur un autre environnement d'exécution (un autre ordinateur, un server, etc.), les choses ne se passent pas du tout comme attendu. Cela signifique qu'**en l'état, le projet n'est pas portable : il n'est pas possible, sans modifications coûteuses, de l'exécuter dans un environnement différent de celui dans lequel il a été développé**.

La principale raison est qu'un code ne vit pas dans une bulle isolée, il contient en général de nombreuses adhérences, plus ou moins visibles, au langage et à l'environnement dans lesquels il a été développé :
- des dépendances dans le langage du projet  ;
- des dépendances dans d'autres langages (ex : `NumPy` est écrit en C et nécessite donc un compilateur C) ;
- des librairies systèmes nécessaires pour installer certains packages (ex : les librairies de cartographie dynamique comme `Leaflet` nécessitent la librairie système `GDAL`), qui ne seront pas les mêmes selon le système d'exploitation utilisé.

Si le premier problème peut être géré relativement facilement en adoptant une [structure de package]({{< ref "/content/code-architecture.md" >}}) et en spécifiant bien les différentes dépendances utilisées, les deux autres nécessitent en général des outils plus avancés.

Ces outils vont nous permettre de **normaliser l'environnement afin de produire un projet portable**, i.e. exécutable sur une large variété d'environnements d'exécution. Cette étape est primordiale lorsque l'on se préoccupe de la mise en production d'un projet, car elle assure une transition relativement indolore entre l'environnement de développement et celui de production.




# Les environnements virtuels

## Introduction

Pour illustrer l'importance de travailler avec des environnements virtuels, mettons-nous à la place d'un.e aspirant *data scientist* qui commencerait ses premiers projets. Selon toute vraisemblance, il va commencer par installer une distribution de Python — souvent, via Anaconda — sur son poste et commencer à développer, projet après projet. Dans cette approche, les différents *packages* qu'il va être amené à utiliser vont être installés au même endroit. Cela pose plusieurs problèmes :
- **conflits de version** : une application A peut dépendre de la version 1 d'un package là où une application B peut dépendre de la version 2 de ce même package. Une seule application peut donc fonctionner dans cette configuration ;
- **version de Python fixe** — on ne peut avoir qu'une seule installation par système — là où on voudrait pouvoir avoir des versions différentes selon le projet ;
- **reproductiblité limitée** : difficile de dire quel projet repose sur tel package, dans la mesure où ceux-ci s'accumulent en un même endroit au fil des projets ;
- **portabilité limitée** : conséquence du point précédent, il est difficile de fixer dans un fichier les dépendances spécifiques à un projet.

Les environnements virtuels constituent une solution à ces différents problèmes.

## Fonctionnement

Le concept d'environnement virtuel est techniquement très simple. En Python, il s'agit d'un "dossier auto-suffisant qui contient une installation de Python pour une version particulière de Python ainsi que des *packages* additionnels", et qui est isolé des autres environnements existants. 

On peut donc simplement voir les environnements virtuels comme un moyen de faire cohabiter sur un même système différentes installations de Python avec chacune leur propre liste de packages installés et leurs versions. Développer dans des environnements virtuels vierges à chaque début de projet est une très bonne pratique pour accroître la reproductibilité des analyses.

## Implémentations

Il existe différentes implémentations des environnements virtuels en Python, dont chacune ont leurs spécificités et leur communauté d'utilisateurs. 

L'implémentation standard en Python est `venv`. Dans le domaine de la *data science*, l'implémentation la plus courante est sans doute `Conda`. En pratique, ces implémentations sont relativement proches. La différence majeure est que `Conda` est à la fois un *package manager* (comme `pip`) et un gestionnaire d'environnements virtuels (comme `venv`). Pendant longtemps, `Conda` en tant que *package manager* s'est avéré très pratique en *data science*, dans la mesure où il gérait non seulement les dépendances Python mais aussi dans d'autres langages — comme des dépendances `C`. Par ailleurs, la *distribution* `Anaconda`, qui contient à la fois Python, `Conda` et beaucoup de *packages* utiles pour la *data science*, explique également cette popularité auprès des *data scientists*. 

Pour toutes ces raisons, nous allons présenter l'utilisation de `Conda` comme gestionnaire d'environnements virtuels. Les principes présentés restent néanmoins valides pour les autres implémentations

## Conda

### Installation



### Fonctionnement

## Limites


# Les conteneurs

## Introduction

## Fonctionnement

## Implémentations

## Limites
