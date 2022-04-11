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

Pour illustrer l'importance de travailler avec des environnements virtuels, mettons-nous à la place d'un.e aspirant *data scientist* qui commencerait ses premiers projets. Selon toute vraisemblance, il va commencer par installer une distribution de `Python` — souvent, via Anaconda — sur son poste et commencer à développer, projet après projet. Dans cette approche, les différents *packages* qu'il va être amené à utiliser vont être installés au même endroit. Cela pose plusieurs problèmes :
- **conflits de version** : une application A peut dépendre de la version 1 d'un package là où une application B peut dépendre de la version 2 de ce même package. Une seule application peut donc fonctionner dans cette configuration ;
- **version de `Python` fixe** — on ne peut avoir qu'une seule installation par système — là où on voudrait pouvoir avoir des versions différentes selon le projet ;
- **reproductiblité limitée** : difficile de dire quel projet repose sur tel package, dans la mesure où ceux-ci s'accumulent en un même endroit au fil des projets ;
- **portabilité limitée** : conséquence du point précédent, il est difficile de fixer dans un fichier les dépendances spécifiques à un projet.

Les environnements virtuels constituent une solution à ces différents problèmes.

## Fonctionnement

Le concept d'environnement virtuel est techniquement très simple. En `Python`, il s'agit d'un "dossier auto-suffisant qui contient une installation de `Python` pour une version particulière de `Python` ainsi que des *packages* additionnels", et qui est isolé des autres environnements existants. 

On peut donc simplement voir les environnements virtuels comme un moyen de faire cohabiter sur un même système différentes installations de `Python` avec chacune leur propre liste de packages installés et leurs versions. Développer dans des environnements virtuels vierges à chaque début de projet est une très bonne pratique pour accroître la reproductibilité des analyses.

## Implémentations

Il existe différentes implémentations des environnements virtuels en `Python`, dont chacune ont leurs spécificités et leur communauté d'utilisateurs. 

L'implémentation standard en `Python` est `venv`. Dans le domaine de la *data science*, l'implémentation la plus courante est sans doute `conda`. En pratique, ces implémentations sont relativement proches. La différence majeure est que `conda` est à la fois un *package manager* (comme `pip`) et un gestionnaire d'environnements virtuels (comme `venv`). Pendant longtemps, `conda` en tant que *package manager* s'est avéré très pratique en *data science*, dans la mesure où il gérait non seulement les dépendances `Python` mais aussi dans d'autres langages — comme des dépendances `C`. Par ailleurs, la *distribution* `Anaconda`, qui contient à la fois `Python`, `conda` et beaucoup de *packages* utiles pour la *data science*, explique également cette popularité auprès des *data scientists*. 

Pour toutes ces raisons, nous allons présenter l'utilisation de `conda` comme gestionnaire d'environnements virtuels. Les principes présentés restent néanmoins valides pour les autres implémentations

## Conda

### Installation

Les instructions à suivre pour installer `conda` sont détaillées dans la [documentation officielle](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html). `conda` seul étant peu utile en pratique, il est généralement installé dans le cadre de distributions. Les deux plus populaires sont :
- `Miniconda` : une distribution minimaliste contenant `conda`, `Python` ainsi qu'un petit nombre de packages techniques très utiles ;
- `Anaconda` : une distribution assez volumineuse contenant `conda`, `Python`, d'autres logiciels (`R`, `Spyder`, etc.) ainsi qu'un ensemble de packages utiles pour la *data science* (`SciPy`, `NumPy`, etc.).

Le choix de la distribution importe assez peu en pratique, dans la mesure où nous allons de toute manière utiliser des environnements virtuels vierges pour développer nos projets.

**L'écosystème Conda**

![](/conda-eco.png)

### Fonctionnement

#### Créer un environnement

Pour commencer à utiliser Conda, commençons par créer un environnement vierge, nommé `dev`, en spécifiant la version de Python que l'on souhaite installer pour notre projet.

```bash
$ conda create -n dev python=3.9.7
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /home/coder/local/bin/conda/envs/dev

  added / updated specs:
    - python=3.9.7


The following packages will be downloaded:
...
The following NEW packages will be INSTALLED:
...
Proceed ([y]/n)? y
Downloading and Extracting Packages
...
```

Comme indiqué dans les logs, Conda a créé notre environnement et nous indique son emplacement sur le *filesystem*. En réalité, l'environnement n'est jamais vraiment vierge : Conda nous demande — et il faut répondre oui en tapant "y" — d'installer un certain nombre de packages, qui sont ceux qui viennent avec la distribution Miniconda.

On peut vérifier que l'environnement a bien été créé en listant les environnements installés sur le système.

```bash
# conda environments:
#
base                    * /home/coder/local/bin/conda
basesspcloud              /home/coder/local/bin/conda/envs/basesspcloud
dev                       /home/coder/local/bin/conda/envs/dev
```

#### Activer un environnement

Comme plusieurs environnements peuvent coexister sur un même système, il faut spécifier à Conda que l'on souhaite utiliser cet environnement pour la session courante du terminal.

```bash
$ conda activate dev
```

Conda nous indique que l'on travaille à partir de maintenant dans l'environnement `dev` en indiquant son nom entre parenthèses au début de la ligne de commandes. Pour s'en assurer, vérifions avec la commande `which` l'emplacement de l'interpréteur Python qui sera utilisé si on lance une commande du type `python mon-script.py`.

```bash
(dev) $ which python 
/home/coder/local/bin/conda/envs/dev/bin/python
```

On travaille bien dans l'environnement attendu : l'interpréteur qui se lance n'est pas celui du système global, mais bien celui spécifique à notre environnement virtuel.

#### Lister les packages installés

Une fois l'environnement activé, on peut lister les packages installés et leur version. Cela confirme qu'un certain nombre de packages sont installés par défaut lors de la création d'un environnement virtuel.

```bash
(dev) $ conda list
# packages in environment at /home/coder/local/bin/conda/envs/dev:
#
# Name                    Version                   Build  Channel
_libgcc_mutex             0.1                        main  
_openmp_mutex             4.5                       1_gnu  
ca-certificates           2022.3.29            h06a4308_0  
...
```

#### Installer un package

La syntaxe pour installer un package avec Conda est très similaire à celle de `pip` : `conda install nom_du_package`. La différence est que là où `pip install` va installer un package à partir du répertoire [PyPI](https://pypi.org/), `conda install` va chercher le package sur les répertoires maintenus par les développeurs de Conda. Installons par exemple le package phare de *machine learning* `scikit-learn`.

```bash
(dev) $ conda install scikit-learn
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /home/coder/local/bin/conda/envs/dev

  added / updated specs:
    - scikit-learn
...
```

Là encore, Conda nous demande d'installer d'autres packages, qui sont des dépendances de `scikit-learn`. Par exemple, la librairie de calcul scientifique `NumPy`.

L'autre différence majeure avec `pip` est que Conda utilise une méthode plus avancée — et donc également plus coûteuse en temps — de résolution des dépendances. En effet, différents packages peuvent spécifier différentes versions d'un même package dont ils dépendent tous les deux, ce qui provoque un conflit de version. Conda va par défaut appliquer un algorithme qui vise à gérer au mieux ces conflits, là où `pip` va choisir une approche plus minimaliste.

Il arrive que des packages disponibles sur le répertoire `PyPI` ne soient pas disponible sur les canaux gérés par Conda. Dans ce cas, il est possible d'installer un package dans l'environnement via la commande `pip install`. Il est néanmonins toujours préférable de privilégier une installation via Conda si disponible.

#### Exporter les spécifications de l'environnement

Développer à partir d'un environnement vierge est une bonne pratique de reproductibilité : en partant d'une base minimale, on s'assure que seuls les packages effectivement nécessaire au bon fonctionnement de notre application ont été installés au fur et à mesure du projet. 

Cela rend également notre projet plus portable : on peut exporter les spécifications de l'environnement (version de Python, canaux de téléchargement des packages, packages installés et leurs versions) dans un fichier, appelé par convention `environment.yml`.

```bash
(dev) $ conda env export > environment.yml
```

Ce fichier est mis par convention à la racine du dépôt Git du projet. Ainsi, les personnes souhaitant tester l'application peuvent recréer le même environnement Conda que celui qui a servi au développement via la commande suivante.

```bash
$ conda env create -f environment.yml
```

#### Changer d'environnement

Pour changer d'environnement, il suffit d'en activer un autre.

```bash
(dev) $ conda base
(base) $ 
```

Pour sortir de tout environnement Conda, on utilise la commande `conda deactivate` :

```bash
(base) $ conda deactivate
$ 
```

#### Supprimer un environnement

Pour supprimer l'environnement `dev`, on utilise la commande `conda env remove -n dev`.

## Limites

Développer dans des environnements virtuels est une bonne pratique, car cela accroît la portabilité d'une application. Néanmoins, il y a plusieurs limites à leur utilisation :
- les librairies système nécessaires à l'installation des packages ne sont pas gérées ;
- devoir installer `conda`, `Python`, et les packages nécessaires à chaque changement d'environnement peut être assez long et pénible en pratique ;
- les environnements virtuels ne permettent pas toujours de gérer des projets faisant intervenir différents langages de programmation ;
- dans un environnement de production, gérer des environnements virtuels différents pour chaque projet peut s'avérer rapidement complexe pour les administrateurs système.

La technologie des conteneurs permet de résoudre ces différents problèmes.

# Les conteneurs

## Introduction

## Fonctionnement

## Implémentations

## Limites
