---
title: "Rendre son projet de data science portable et reproductible"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---


# La notion de portabilité

Dans les chapitres précédents, nous avons vu un ensemble de bonnes pratiques qui permettent de considérablement améliorer la qualité d'un projet : rendre le code plus lisible, adopter une structure du projet normalisée et évolutive, et versionner proprement son code sur un dépôt `GitHub`.

Une fois ces bonnes pratiques appliquées à notre projet, ce dernier apparaît largement partageable. Du moins en théorie, car la pratique est souvent plus compliquée : il y a fort à parier que si vous essayez d'exécuter votre projet sur un autre environnement d'exécution (un autre ordinateur, un serveur, etc.), les choses ne se passent pas du tout comme attendu. Cela signifique qu'**en l'état, le projet n'est pas portable : il n'est pas possible, sans modifications coûteuses, de l'exécuter dans un environnement différent de celui dans lequel il a été développé**.

La principale raison est qu'un code ne vit pas dans une bulle isolée, il contient en général de nombreuses adhérences, plus ou moins visibles, au langage et à l'environnement dans lesquels il a été développé :
- des dépendances dans le langage du projet  ;
- des dépendances dans d'autres langages (ex : `NumPy` est écrit en `C` et nécessite donc un compilateur `C`) ;
- des librairies systèmes nécessaires pour installer certains _packages_
(par exemple, : les librairies de cartographie dynamique comme `Leaflet` ou `Folium`
nécessitent la librairie système `GDAL`),
qui ne seront pas les mêmes selon le système d'exploitation utilisé.

Si le premier problème peut être géré relativement facilement en adoptant une [structure de package]({{< ref "/content/code-architecture.md" >}}) et en spécifiant bien les différentes dépendances utilisées, les deux autres nécessitent en général des outils plus avancés.

Ces outils vont nous permettre de **normaliser l'environnement afin de produire un projet portable**, i.e. exécutable sur une large variété d'environnements d'exécution. Cette étape est primordiale lorsque l'on se préoccupe de la mise en production d'un projet, car elle assure une transition relativement indolore entre l'environnement de développement et celui de production.

![](https://img.devrant.com/devrant/rant/r_174386_yx6zV.jpg)

Image empruntée à https://devrant.com/rants/174386/when-i-say-but-it-works-on-my-machine



# Les environnements virtuels :snake:

## Introduction

Pour illustrer l'importance de travailler avec des environnements virtuels, mettons-nous à la place d'un.e aspirant *data scientist* qui commencerait ses premiers projets. Selon toute vraisemblance, il va commencer par installer une distribution de `Python` — souvent, via `Anaconda` — sur son poste et commencer à développer, projet après projet. Dans cette approche, les différents *packages* qu'il va être amené à utiliser vont être installés au même endroit. Cela pose plusieurs problèmes :
- **conflits de version** : une application A peut dépendre de la version 1 d'un package là où une application B peut dépendre de la version 2 de ce même package. Une seule application peut donc fonctionner dans cette configuration ;
- **version de `Python` fixe** — on ne peut avoir qu'une seule installation par système — là où on voudrait pouvoir avoir des versions différentes selon le projet ;
- **reproductiblité limitée** : difficile de dire quel projet repose sur tel package, dans la mesure où ceux-ci s'accumulent en un même endroit au fil des projets ;
- **portabilité limitée** : conséquence du point précédent, il est difficile de fixer dans un fichier les dépendances spécifiques à un projet.

Les environnements virtuels constituent une solution à ces différents problèmes.

## Fonctionnement

Le concept d'environnement virtuel est techniquement très simple.
On peut lui donner la définition suivante pour `Python` :

> _"dossier auto-suffisant qui contient une installation de `Python`
pour une version particulière de `Python` ainsi que des *packages* additionnels
et qui est isolé des autres environnements existants."_

On peut donc simplement voir les environnements virtuels comme un moyen de faire cohabiter sur un même système différentes installations de `Python` avec chacune leur propre liste de packages installés et leurs versions. Développer dans des environnements virtuels vierges à chaque début de projet est une très bonne pratique pour accroître la reproductibilité des analyses.

## Implémentations

Il existe différentes implémentations des environnements virtuels en `Python`, dont chacune ont leurs spécificités et leur communauté d'utilisateurs : 

* L'implémentation standard en `Python` est `venv`.
* Dans le domaine de la *data science*, l'implémentation la plus courante est sans doute `conda`.

En pratique, ces implémentations sont relativement proches.
La différence majeure est que `conda` est à la fois un *package manager* (comme `pip`)
et un gestionnaire d'environnements virtuels (comme `venv`).

Pendant longtemps, `conda` en tant que *package manager* s'est avéré très pratique en *data science*, dans la mesure où il gérait non seulement les dépendances `Python` mais aussi dans d'autres langages — comme des dépendances `C`. Par ailleurs, la *distribution* `Anaconda`, qui contient à la fois `Python`, `conda` et beaucoup de *packages* utiles pour la *data science*, explique également cette popularité auprès des *data scientists*. 

Pour toutes ces raisons, nous allons présenter l'utilisation de `conda` comme gestionnaire d'environnements virtuels. Les principes présentés restent néanmoins valides pour les autres implémentations

## Conda

### Installation

Les instructions à suivre pour installer `conda` sont détaillées dans la [documentation officielle](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html). `conda` seul étant peu utile en pratique, il est généralement installé dans le cadre de distributions. Les deux plus populaires sont :
- `Miniconda` : une distribution minimaliste contenant `conda`, `Python` ainsi qu'un petit nombre de packages techniques très utiles ;
- `Anaconda` : une distribution assez volumineuse contenant `conda`, `Python`, d'autres logiciels (`R`, `Spyder`, etc.) ainsi qu'un ensemble de packages utiles pour la *data science* (`SciPy`, `NumPy`, etc.).

Le choix de la distribution importe assez peu en pratique, dans la mesure où nous allons de toute manière utiliser des environnements virtuels vierges pour développer nos projets.

**L'écosystème Conda**

![](/conda-eco.png)

### En pratique

#### Créer un environnement

Pour commencer à utiliser `conda`, commençons par créer un environnement vierge, nommé `dev`, en spécifiant la version de Python que l'on souhaite installer pour notre projet.

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
conda info --envs
# conda environments:
#
base                    * /home/coder/local/bin/conda
basesspcloud              /home/coder/local/bin/conda/envs/basesspcloud
dev                       /home/coder/local/bin/conda/envs/dev
```

#### Activer un environnement

Comme plusieurs environnements peuvent coexister sur un même système,
il faut spécifier à `Conda`
que l'on souhaite utiliser cet environnement pour la session courante du terminal.

```bash
$ conda activate dev
```

`Conda` nous indique que l'on travaille à partir de maintenant dans l'environnement `dev` en indiquant son nom entre parenthèses au début de la ligne de commandes. Autrement dit, `dev` devient pour un temps notre 
environnement par défaut. 
Pour s'en assurer,
vérifions avec la commande `which` l'emplacement de l'interpréteur Python qui sera utilisé si on lance une commande du type `python mon-script.py`.

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

La syntaxe pour installer un package avec Conda est très similaire à celle de `pip` : 

```shell
conda install nom_du_package
```

La différence est que là où `pip install` va installer un package à partir du répertoire [PyPI](https://pypi.org/), `conda install` va chercher le package sur les répertoires maintenus par les développeurs de Conda[^1]. Installons par exemple le package phare de *machine learning* `scikit-learn`.

[^1]: Ces répertoires sont, dans le langage `conda` les _canaux_.
Le canal par défaut est maintenu par les développeurs d`Anaconda`. 
Cependant, pour en assurer la stabilité, ce canal a une forte inertie. 
La `conda-forge` a émergé pour offrir plus de flexibilité aux développeurs
de _package_ qui peuvent ainsi mettre à disposition des versions plus
récentes de leurs packages, comme sur  [PyPI](https://pypi.org/).


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

L'autre différence majeure avec `pip` est que Conda utilise une méthode plus avancée — et donc également plus coûteuse en temps — de résolution des dépendances. En effet, différents packages peuvent spécifier différentes versions d'un même package dont ils dépendent tous les deux, ce qui provoque un conflit de version. Conda va par défaut appliquer un algorithme qui vise à gérer au mieux ces conflits, là où `pip` va choisir une approche plus minimaliste[^2].

[^2]: [`mamba`](https://mamba.readthedocs.io/en/latest/)
est une alternative au système de gestion de dépendance par
défaut de conda grâce à un _solver_ plus efficace. 
En proposant celui-ci, le projet `mamba` vise à pallier l'un 
des irritants principaux de `conda`, à savoir la lenteur du _solver_.


Il arrive que des packages disponibles sur le répertoire `PyPI`
ne soient pas disponible sur les canaux gérés par Conda.
Dans ce cas, il est possible d'installer un package dans l'environnement via la commande `pip install`.
Il est néanmonins toujours préférable de privilégier une installation via Conda si disponible.

#### Exporter les spécifications de l'environnement

Développer à partir d'un environnement vierge est une bonne pratique de reproductibilité :
en partant d'une base minimale, on s'assure que seuls les packages effectivement nécessaires
au bon fonctionnement de notre application ont été installés au fur et à mesure du projet. 

Cela rend également notre projet plus portable : on peut exporter les spécifications de l'environnement (version de Python, canaux de téléchargement des packages, packages installés et leurs versions) dans un fichier, appelé par convention `environment.yml`.

```bash
(dev) $ conda env export > environment.yml
```

Ce fichier est mis par convention à la racine du dépôt `Git` du projet.
Ainsi, les personnes souhaitant tester l'application peuvent recréer le même environnement Conda que celui qui a servi au développement via la commande suivante.

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

### Aide-mémoire

| Commande | Principe |
|----------|----------|
| `conda create -n <env_name> python=<python_version>` | Création d'un environnement nommé `<env_name>` dont la version de Python est `<python_version>` |
| `conda info --envs` | Lister les environnements |
| `conda activate <env_name>` | Utiliser l'environnement `<env_name>` pour la session du terminal |
| `conda list` | Lister les _packages_ dans l'environnement actif |
| `conda install <pkg>` | Installer le _package_ `<pkg>` dans l'environnement actif |
| `conda env export > environment.yml` | Exporter les spécifications de l’environnement dans un fichier `environment.yml` |



## Limites

Développer dans des environnements virtuels est une bonne pratique, car cela accroît la portabilité d'une application. Néanmoins, il y a plusieurs limites à leur utilisation :
- les librairies système nécessaires à l'installation des packages ne sont pas gérées ;
- les environnements virtuels ne permettent pas toujours de gérer des projets faisant intervenir différents langages de programmation ;
- devoir installer `conda`, `Python`, et les packages nécessaires à chaque changement d'environnement peut être assez long et pénible en pratique ;
- dans un environnement de production, gérer des environnements virtuels différents pour chaque projet peut s'avérer rapidement complexe pour les administrateurs système.

La technologie des conteneurs permet de répondre à ces différents problèmes.

# Les conteneurs

## Introduction

Avec les environnements virtuels, l'idée était de permettre à chaque utilisateur potentiel de notre projet d'installer sur son environnement d'exécution les packages nécessaires à la bonne exécution du projet. Néanmoins, comme on l'a vu, cette approche ne garantit pas une reproductibilité parfaite et a l'inconvénient de nécessiter beaucoup de gestion manuelle.

Changeons de perspective : au lieu de distribuer une recette permettant à l'utilisateur de recréer l'environnement nécessaire sur sa machine, ne pourrait-on pas directement distribuer à l'utilisateur une machine contenant l'environnement pré-configuré ? Bien entendu, on ve pas configurer et envoyer des ordinateurs portables à tous les utilisateurs potentiels d'un projet. Une autre solution serait de distribuer des machines virtuelles, qui tournent sur un serveur et simulent un véritable ordinateur. Ces machines ont cependant l'inconvénient d'être assez lourdes, et complexes à répliquer et distribuer. Pour pallier ces différentes limites, on va utiliser la technologie des conteneurs.

![](https://external-preview.redd.it/aR6WdUcsrEgld5xUlglgKX_0sC_NlryCPTXIHk5qdu8.jpg?auto=webp&s=5fe64dd318eec71711d87805d43def2765dd83cd)

Image trouvée sur [reddit](https://www.reddit.com/r/ProgrammerHumor/comments/cw58z7/it_works_on_my_machine/)

## Fonctionnement

Comme les machines virtuelles, les conteneurs permettent d'empaqueter complètement l'environnement (librairies systèmes, application, configuration) qui permet de faire tourner l'application. Mais à l'inverse d'une machine virtuelle, le conteneur n'inclut pas de système d'exploitation propre, il utilise celui de la machine hôte qui l'exécute. La technologie des conteneurs permet ainsi de garantir une très forte reproductibilité tout en restant suffisamment légère pour permettre une distribution et un déploiement simple aux utilisateurs.

**Différences entre l'approche conteneurs (gauche) et l'approche machines virtuelles (droite)**

![](/docker-vm.png)

Source : [docker.com](https://www.docker.com/resources/what-container/)

## Implémentations

Comme pour les environnements virtuels, il existe différentes implémentations de la technologie des conteneurs. En pratique, l'implémentation offerte par `Docker` est devenue largement prédominante, au point qu'il est devenu courant d'utiliser de manière interchangeable les termes _"conteneuriser"_ et _"Dockeriser"_ une application. C'est donc cette implémentation que nous allons étudier et utiliser dans ce cours.

## Docker <i class="fab fa-docker"></i>

### Installation

Les instructions à suivre pour installer `Docker` <i class="fab fa-docker"></i>
selon son système d'exploiration sont détaillées dans la [documentation officielle](https://docs.docker.com/get-docker/).
Il existe également des environnements bacs à sable en ligne comme
[Play with Docker](https://labs.play-with-docker.com).


### Principes

Un conteneur Docker est mis à disposition sous la forme d'une **image**, c'est à dire d'un fichier binaire qui contient l'environnement nécessaire à l'exécution de l'application.

Pour construire (*build*) l'image, on utilise un `Dockerfile`, un fichier texte qui contient la recette — sous forme de commandes Linux — de construction de l'environnement. L'image va être uploadée (*push*) sur un dépôt (*registry*), public ou privé, depuis lequel les utilisateurs vont pouvoir télécharger l'image (*pull*). Le moteur Docker permet ensuite de lancer (*run*) un **conteneur**, c'est à dire une instance vivante de l'image.


{{% box status="note" title="Note: les commandes Docker" icon="fa fa-comment" %}}
Le répertoire d'images publiques le plus connu
est [`DockerHub`](https://hub.docker.com/). Il s'agit d'un répertoire
où n'importe qui peut proposer une image `Docker`, associée ou non
à un projet disponible sur `Github` <i class="fab fa-github"></i>
ou `Gitlab` <i class="fab fa-gitlab"></i>. 
Il est possible de mettre à
disposition de manière manuelle des images mais, comme nous le montrerons,
il est beaucoup plus pratique d'utiliser des fonctionalités d'interaction
automatique entre `DockerHub` et un dépôt `Git`.
{{% /box %}}



### En pratique

#### Application

Afin de présenter l'utilisation de `Docker` en pratique,
nous allons présenter les différentes étapes permettant de _"dockeriser"_
une application web minimaliste construite avec le
_framework_ `Python` [`Flask`](https://flask.palletsprojects.com/en/2.1.x/)[^2].

[^2]: [`Flask`](https://flask.palletsprojects.com/en/2.1.x/) est un 
_framework_ permettant de déployer, de manière légère,
des applications reposant sur 
`Python`. 

La structure de notre projet est la suivante.

```bash
├── myflaskapp
│   ├── Dockerfile
│   ├── hello-world.py
│   └── requirements.txt
```

Le script `hello-world.py` contient le code d'une application minimaliste, qui affiche simplement _"Hello, World!"_ sur une page web.

```python
from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
```

Pour faire tourner l'application, il nous faut donc à la fois `Python` et le package `Flask`. Ces installations doivent être spécifiées dans le `Dockerfile` (cf. [section suivante](#dockerfile)). L'installation de `Flask`
se fait via un fichier `requirements.txt` (voir le [chapitre précédent](#code-architecture)), qui contient juste la ligne suivante :

```bash
Flask==2.1.1
```

#### Le `Dockerfile` {#dockerfile}

A là base de chaque image `Docker` se trouve un `Dockerfile`. C'est un fichier texte qui contient une série de commandes qui permettent de construire l'image. Ces fichiers peuvent être plus ou moins complexes selon l'application que l'on cherche à conteneuriser, mais leur structure est assez normalisée. Pour s'en rendre compte, analysons ligne à ligne le `Dockerfile` nécessaire pour construire une image `Docker` de notre application `Flask.`

```bash
FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev
    
WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

COPY . /app

ENV FLASK_APP="hello-world.py"
EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
```

- `FROM` : spécifie l'image de base. Une image Docker hérite toujours d'une image de base. Ici, on choisit l'image `Ubuntu` version `20.04`, tout va donc se passer comme si l'on développait sur une machine virtuelle vierge ayant pour système d'exploitation `Ubuntu 20.04`[^3] ;
- `RUN` : lance une commande Linux. Ici, on met d'abord à jour la liste des packages téléchargeables via `apt`, puis on installe `Python` ainsi que des librairies système nécessaires au bon fonctionnement de notre application ;
- `WORKDIR` : spécifie le répertoire de travail de l'image. Ainsi, toutes les commandes suivantes seront exécutées depuis ce répertoire ;
- `COPY` : copie un fichier local sur l'image `Docker`. Ici, on copie d'abord le fichier `requirements.txt` du projet, qui spécifie les dépendances `Python` de notre application, puis on les installe avec une commande `RUN`. La seconde instruction `COPY` copie le répertoire du projet sur l'image ;
- `ENV` : crée une variable d'environnement qui sera accessible à l'application dans le conteneur. Ici, on définit une variable d'environnement attendue par `Flask`, qui spécifie le nom du script permettant de lancer l'application ;
- `EXPOSE` : informe `Docker` que le conteneur "écoute" sur le port 5000, qui est le port par défaut utilisé par le serveur web de `Flask` ;
- `CMD` : spécifie la commande que doit exécuter le conteneur lors de son lancement. Il s'agit d'une liste, qui contient les différentes parties de la commande sous forme de chaînes de caractères. Ici, on lance `Flask`, qui sait automatiquement quelle application lancer du fait de la commande `ENV` spécifiée précédemment.

[^3]: Dans l'idéal, on essaie de partir d'une couche la plus petite possible
pour limiter la taille de l'image finalement obtenue. Il n'est en effet
pas nécessaire d'utiliser une image disposant de `R` si on n'utilise que
du `Python`. En général, les différents langages proposent des images de petite taille dans lequel un interpréteur est déjà installé et proprement configuré. Dans cette application, on aurait par exemple pu utiliser l'image [python:3.9-slim-buster](https://hub.docker.com/layers/python/library/python/3.9-slim-buster/images/sha256-e07b35c0c81c21995a43cefd64730ac0e57a5164cc440b6a5c94c118cfacd0ca?context=explore).



{{% box status="hint" title="Hint: choix des librairies système" icon="fa fa-lightbulb" %}}
Avec la première commande `RUN` du `Dockerfile`, nous installons `Python` mais aussi des librairies système nécessaires au bon fonctionnement de l'application. Mais comment les avons-nous trouvées ?

Par essai et erreur. Lors de l'étape de [build](#build) que l'on verra juste après, le moteur `Docker` va essayer de construire l'image selon les spécifications du `Dockerfile`, comme s'il partait d'un ordinateur vide contenant simplement `Ubuntu 20.04`. Si des librairies manquent, le processus de *build* devrait renvoyer une erreur, qui s'affichera dans les *logs* de l'application, affichés par défaut dans la console. Quand on a de la chance, les logs décrivent explicitement les librairies système manquantes. Mais souvent, les messages d'erreur ne sont pas très explicites, et il faut alors les copier dans un moteur de recherche bien connu pour trouver la réponse, souvent sur [Stackoverflow](https://stackoverflow.com/).
{{% /box %}}

{{% box status="hint" title="Hint: pourquoi `COPY` ?" icon="fa fa-lightbulb" %}}
La recette présente dans le `Dockerfile` peut nécessiter l'utilisation de
fichiers appartenant au dossier de travail. Pour que `Docker` les trouve
dans son contexte, il est nécessaire d'introduire une
commande `COPY`. C'est un petit peu comme pour la cuisine: pour utiliser
un produit dans une recette, il faut le sortir du frigo (fichier local)
et le mettre sur la table. 

{{% /box %}}


{{% box status="note" title="Note: les commandes Docker" icon="fa fa-comment" %}}
Nous n'avons vu que les commandes `Docker` les plus fréquentes, il en existe beaucoup d'autres en pratique. N'hésitez pas à consulter la [documentation officielle](https://docs.docker.com/engine/reference/builder/) pour comprendre leur utilisation.
{{% /box %}}

#### Construction d'une image Docker {#build}

Pour construire une image à partir d'un `Dockerfile`, il suffit d'utiliser la commande `docker build`. Il faut ensuite spécifier deux éléments importnats :
- le *build context*. Il faut indiquer à `Docker` le chemin de notre projet, qui doit contenir le `Dockerfile`. En pratique, il est plus simple de se mettre dans le dossier du projet via la commande `cd`, puis de passer `.` comme *build context* pour indiquer à `Docker` de *build* "d'ici" ;
- le *tag*, c'est à dire le nom de l'image. Tant que l'on utilisee `Docker` en local, le *tag* importe peu. On verra par la suite que la structure du *tag* a de l'importance lorsque l'on souhaite [exporter ou importer une image `Docker`](#imp-exp-docker) à partir d'un dépôt distant.

Regardons ce qui se passe en pratique lorsque l'on essaie de construire notre image.

```bash
$ docker build -t myflaskapp .
Sending build context to Docker daemon     47MB
Step 1/8 : FROM ubuntu:20.04
 ---> 825d55fb6340
Step 2/8 : RUN apt-get update && apt-get install -y python3-pip python3-dev
 ---> Running in 92b42d579cfa
...
done.
Removing intermediate container 92b42d579cfa
 ---> 8826d53e3c01
Step 3/8 : WORKDIR /app
 ---> Running in 153b32893c23
Removing intermediate container 153b32893c23
 ---> 7b4d22021986
Step 4/8 : COPY requirements.txt /app/requirements.txt
...
Successfully built 125bd8da70ff
Successfully tagged myflaskapp:latest
```

Le moteur `Docker` essaie de construire notre image séquentiellement à partir des commandes spécifiées dans le `Dockerfile`. S'il rencontre une erreur, la procédure s'arrête, et il faut alors trouver la source du problème dans les *logs* et adapter le `Dockerfile` en conséquence. Si tout se passe bien, `Docker` nous indique que le *build* a réussi et l'image est prête à être utilisée. On peut vérifier que l'image est bien disponible à l'aide de la commande `docker images`.

```bash
$ docker images
REPOSITORY                               TAG       IMAGE ID       CREATED          SIZE
myflaskapp                               latest    57d2f410a631   2 hours ago      433MB
```

Intéressons nous un peu plus en détail aux *logs* de l'étape de *build*. Entre les étapes, `Docker` affiche des suites de lettres et de chiffres un peu ésotériques, et nous parle de conteneurs intermédiaires. En fait, il faut voir une image `Docker` comme un empilement de couches (*layers*), qui sont elles-mêmes des images `Docker`. Quand on hérite d'une image avec l'instruction `FROM`, on spécifie donc à `Docker` la couche initiale, sur laquelle il va construire le reste de notre environnement. A chaque étape sa nouvelle couche, et à chaque couche son *hash*, un identifiant unique fait de lettres et de chiffres.

Cela peut ressembler à des détails techniques, mais c'est en fait extrêmement utile en pratique car cela permet à `Docker` de faire du *caching*. Lorsque l'on développe un `Dockerfile`, il est fréquent de devoir modifier ce dernier de nombreuses fois avant de trouver la bonne recette, et on aimerait bien ne pas avoir à *rebuild* l'environnement complet à chaque fois. `Docker` gère cela très bien : il *cache* chacune des couches intermédiaires. Par exemple, si l'on modifie la 5ème commande du `Dockerfile`, `Docker` va utiliser le cache pour ne pas avoir à recalculer les étapes précédentes, qui n'ont pas changé. Cela s'appelle l'_"invalidation du cache"_ :
dès lors qu'une étape du `Dockerfile` est modifiée, `Docker` va recalculer toutes les étapes suivantes, mais seulement celles-ci. Conséquence directe de cette observation : il faut toujours ordonner les étapes d'un `Dockerfile` de sorte à ce qui est le plus susceptible d'être souvent modifié soit à la fin du fichier, et inversement.

Pour illustrer cela, regardons ce qui se passe si l'on modifie le nom du script qui lance l'application, et donc la valeur de la variable d'environnement `FLASK_APP` dans le `Dockerfile`.

```bash
$ docker build . -t myflaskapp
Sending build context to Docker daemon  4.096kB
Step 1/10 : FROM ubuntu:20.04
 ---> 825d55fb6340
Step 2/10 : ENV DEBIAN_FRONTEND=noninteractive
 ---> Using cache
 ---> ea1c7c083ac9
Step 3/10 : RUN apt-get update -y &&     apt-get install -y python3-pip python3-dev
 ---> Using cache
 ---> 078b8ac0e1cb
Step 4/10 : WORKDIR /app
 ---> Using cache
 ---> cd19632825b3
Step 5/10 : COPY requirements.txt /app/requirements.txt
 ---> Using cache
 ---> 271cd1686899
Step 6/10 : RUN pip install -r requirements.txt
 ---> Using cache
 ---> 3ea406fdf383
Step 7/10 : COPY . /app
 ---> 3ce5bd3a9572
Step 8/10 : ENV FLASK_APP="new.py"
 ---> Running in b378d16bb605
Removing intermediate container b378d16bb605
 ---> e1f50490287b
Step 9/10 : EXPOSE 5000
 ---> Running in ab53c461d3de
Removing intermediate container ab53c461d3de
 ---> 0b86eca40a80
Step 10/10 : CMD ["flask", "run", "--host=0.0.0.0"]
 ---> Running in 340eec151a51
Removing intermediate container 340eec151a51
 ---> 16d7a5b8db28
Successfully built 16d7a5b8db28
Successfully tagged myflaskapp:latest
```

L'étape de *build* a pris quelques secondes au lieu de plusieurs minutes, et les *logs* montrent bien l'utilisation du cache faite par `Docker` : les étapes précédant le changement réutilisent les couches cachées, mais celle d'après sont recalculées.

#### Exécuter une image `Docker` {#execution}

L'étape de *build* a permis de créer une *image* `Docker`. Une image doit être vue comme un *template* : elle permet d'exécuter l'application sur n'importe quel environnement d'exécution sur lequel un moteur `Docker` est installé. En l'état, on a donc juste *construit*, mais rien *lancé* : notre application ne tourne pas encore. Pour cela, il faut créer un *conteneur*, i.e. une instance vivante de l'image qui permet d'accéder à l'application. Cela se fait via la commande `docker run`.

```bash
$ docker run -d -p 8000:5000 myflaskapp:latest
6a2ab0d82d051a3829b182ede7b9152f7b692117d63fa013e7dfe6232f1b9e81
```

Détaillons la syntaxe de cette commande :
- `docker run tag` : lance l'image dont on fournit le *tag*. Le *tag* est de la forme `repository/projet:version`. Ici, il n'y a pas de *repository* puisque tout est fait en local ;
- `-d` : "détache" le conteneur du terminal qui le lance ;
- `-p` : effectue un *mapping* entre un port de la machine qui exécute le conteneur, et le conteneur lui-même. Notre conteneur écoute sur le port 5000, et l'on veut que notre application soit exposée sur le port 8000 de notre machine.

Lorsque l'on exécute `docker run`, `Docker` nous répond simplement un *hash* qui identifie le conteneur que l'on a lancé. On peut vérifier qu'il tourne bien avec la commande `docker ps`, qui renvoie toutes les informations associées au conteneur.

```bash
$ docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED         STATUS         PORTS                                   NAMES
6a2ab0d82d05   myflaskapp   "flask run --host=0.…"   7 seconds ago   Up 6 seconds   0.0.0.0:8000->5000/tcp, :::8000->5000/tcp   vigorous_kalam
```

Les conteneurs peuvent être utilisés pour réaliser des tâches très différentes. Grossièrement, on peut distinguer deux situations :
- le conteneur effectue une tâche "one-shot", c'est à dire une opération qui a vocation à s'effectuer en un certain temps, suite à quoi le conteneur peut s'arrêter ;
- le conteneur exécute une application. Dans ce cas, on souhaite que le conteneur reste en vie aussi longtemps que l'on souhaite utiliser l'application en question.

Dans notre cas d'application, on se situe dans la seconde configuration puisque l'on veut exécuter une application web. Lorsque l'application tourne, elle expose sur le *localhost*, accessible depuis un navigateur web — en l'occurence, à l'adresse [localhost:8000/](localhost:8000/). Les calculs sont effectués sur un serveur local, et le navigateur sert d'interface avec l'utilisateur — comme lorsque vous utilisez un notebook `Jupyter` par exemple. 

Finalement, on a pu développer et exécuter une application complète sur notre environnement local, sans avoir eu à installer quoi que ce soit sur notre machine personnelle, à part `Docker.`

#### Exporter une image `Docker` {#imp-exp-docker}

Jusqu'à maintenant, toutes les commandes `Docker` que nous avons exécutées se sont passées en local. Ce mode de fonctionnement peut être intéressant pour la phase de développement. Mais comme on l'a vu, un des gros avantages de `Docker` est la facilité de redistribution des images construites, qui peuvent ensuite être utilisées par de nombreux utilisateurs pour faire tourner notre application. Pour cela, il nous faut uploader notre image sur un dépôt distant, à partir duquel les utilisateurs pourront la télécharger.

Plusieurs possibilités existent selon le contexte de travail : une entreprise peut avoir un dépôt interne par exemple. Si le projet est open-source, on peut utiliser le [DockerHub](https://hub.docker.com/). Le *workflow* pour uploader une image est le suivant :
- créer un compte sur le DockerHub ;
- créer un projet (public) sur le DockerHub, qui va héberger les images `Docker` du projet ;
- sur un terminal, utiliser `docker login` pour s'authentifier au `DockerHub` ;
- on va modifier le *tag* que l'on fournit lors du *build* pour spécifier le chemin attendu. Dans notre cas : `docker build -t compte/projet:version .` ;
- uploader l'image avec `docker push compte/projet:version`

```bash
$ docker push avouacr/myflaskapp:1.0.0
The push refers to repository [docker.io/avouacr/myflaskapp]
71db96687fe6: Pushed 
624877ac887b: Pushed 
ea4ab6b86e70: Pushed 
b5120a5bc48d: Pushed 
5fa484a3c9d8: Pushed 
c5ec52c98b31: Pushed 
1.0.0: digest: sha256:b75fe53fd1990c3092ec41ab0966a9fbbb762f3047957d99327cc16e27c68cc9 size: 1574
```

#### Importer une image `Docker` {#imp-exp-docker}

En supposant que le dépôt utilisé pour uploader l'image est public, la procédure que doit suivre un utilisateur pour la télécharger se résume à utiliser la commande `docker pull compte/projet:version`

```bash
$ docker pull avouacr/myflaskapp:1.0.0
1.0.0: Pulling from avouacr/myflaskapp
e0b25ef51634: Pull complete 
c0445e4b247e: Pull complete 
48ba4e71d1c2: Pull complete 
ffd728caa80a: Pull complete 
906a95f00510: Pull complete 
d7d49b6e17ab: Pull complete 
Digest: sha256:b75fe53fd1990c3092ec41ab0966a9fbbb762f3047957d99327cc16e27c68cc9
Status: Downloaded newer image for avouacr/myflaskapp:1.0.0
docker.io/avouacr/myflaskapp:1.0.0
```

`Docker` télécharge et extrait chacune des couches qui constituent l'image (ce qui peut parfois être long). L'utilisateur peut alors créer un conteneur à partir de l'image, en utilisant `docker run` comme illustré précédemment.

### Aide-mémoire

Voici une première aide-mémoire sur les principales commandes à intégrer dans 
un `Dockerfile`:

| Commande | Principe |
|----------|----------|
| `FROM <image>:<tag>` | Utiliser comme point de départ l'image `<image>` ayant le tag `<tag>` |
| `RUN <instructions>` | Utiliser la suite d'instructions `<instructions>` dans un terminal `Linux`. Pour passer plusieurs commandes dans un `RUN`, utiliser `&&`. Cette suite de commande peut avoir plusieurs lignes, dans ce cas, mettre `\` en fin de ligne |
| `COPY <source> <dest>` | Récupérer le fichier présent dans le système de fichier local à l'emplacement `<source>` pour que les instructions ultérieures puissent le trouver à l'emplacement `<source>`   |
| `ADD <source> <dest>` | Globalement, même rôle que `COPY` |
| `ENV MY_NAME="John Doe"` | Création d'une variable d'environnement (qui devient disponible sous l'alias `$MY_NAME`)   |
| `WORKDIR <path>` | Définir le _working directory_ du conteuneur Docker dans le dossier `<path>`  |
| `USER <username>` | Création d'un utilisateur non _root_ nommé `<username>`  |
| `EXPOSE <PORT_ID>` | Lorsqu'elle tournera, l'application sera disponible depuis le port `<PORT_ID>`
| `CMD ["executable","param1","param2"]` | Au lancement de l'instance Docker la commande `executable` (par exemple `python3`) sera lancée avec les paramètres additionnels fournis  |

Une seconde aide-mémoire pour les principales commandes `Linux` est disponible ci-dessous:

| Commande | Principe |
|----------|----------|
| `docker build . -t <tag>` | Construire l'image `Docker` à partir des fichiers dans le répertoire courant (`.`) en l'identifiant avec le tag `<tag>`  |
| `docker run -it <tag>` | Lancer l'instance docker identifiée par `<tag>`  |
| `docker images` | Lister les images disponibles sur la machine et quelques unes de leurs propriétés (tags, volume, etc.) |
| `docker system prune` | Faire un peu de ménage dans ses images `Docker` (bien réfléchir avant de faire tourner cette commande) |

