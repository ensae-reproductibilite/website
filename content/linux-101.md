---
title: "Démystifier le terminal Linux pour gagner en autonomie"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---



# Le terminal Linux
  
## Pourquoi s'intéresser au terminal Linux ?

Le terminal (ou ligne de commande) est une console interactive qui permet de lancer des commandes. Il existe dans la plupart des systèmes d'exploitation. Mais comme il a la réputation d'être austère et complexe, on utilise plutôt des interfaces graphiques pour effectuer nos opérations informatiques quotidiennes.

Pourtant, avoir des notions quant à l'utilisation d'un terminal est une vraie source d'autonomie, dans la mesure où celui-ci permet de gérer bien plus finement les commandes que l'on réalise. Pour le data scientist qui s'intéresse aux bonnes pratiques et à la mise en production, sa maîtrise est essentielle. Les raisons sont multiples :

- les interfaces graphiques des logiciels sont généralement limitées par rapport à l'utilisation du programme en ligne de commande. C'est par exemple le cas de **Git** et de **Docker**. Dans les deux cas, seul le client en ligne de commande permet de réaliser toutes les opérations permises par le logiciel ;

- mettre un projet de data science en production nécessite d'utiliser un serveur, qui le rend disponible en permanence à son public potentiel. Or là où Windows domine le monde des ordinateurs personnels, une large majorité des serveurs et des infrastructures cloud fonctionnent sous Linux.

- plus généralement, une utilisation régulière du terminal est source d'une meilleure compréhension du fonctionnement d'un système de fichiers et de l'exécution des processus sur un ordinateur. Ces connaissances s'avèrent très utiles dans la pratique quotidienne du data scientist, qui nécessite de plus en plus de développer dans différents environnements d'exécution.

Dans le cadre de ce cours, on s'intéressera donc particulièrement au terminal Linux.

## Environnement de travail

Différents environnements de travail peuvent être utilisés pour apprendre à se servir d'un terminal Linux :

- le [SSP Cloud](https://datalab.sspcloud.fr). Dans la mesure où les exemples de mise en production du cours seront illustrées sur cet environnement, nous recommendons de l'utiliser dès à présent pour se familiariser. Le terminal est accessible à partir de différents services (RStudio, Jupyter, etc.), mais nous recommandons d'utiliser le terminal d'un service VSCode, dans la mesure où se servir d'un [IDE](https://fr.wikipedia.org/wiki/Environnement_de_d%C3%A9veloppement) pour organiser notre code est en soi déjà une bonne pratique ;

- [Katacoda](https://katacoda.com/scenario-examples/courses/environment-usages/ubuntu-2004), un bac à sable dans un système Ubuntu, la distribution Linux la plus populaire ;

- sur Windows : Git Bash (émulation minimaliste d'un terminal Linux), qui est installée par défaut avec Git.

## Introduction au terminal

Lançons un terminal pour présenter son fonctionnement basique. On prend pour exemple le terminal d'un service VSCode lancé via le SSP Cloud (*Application Menu* tout en haut à gauche de VSCode -> *Terminal* -> *New Terminal*). Voici à quoi ressemble le terminal en question.

![](/terminal.png)

Décrivons d'abord les différentes inscriptions qui arrivent à l'initialisation :
- `(base)` : cette inscription n'est pas directement liée au terminal, elle provient du fait que l'on utilise un environnement `conda`. Nous verrons le fonctionnement des environnements virtuels en détail dans le chapitre sur la [portabilité]({{< ref "/content/portability.md" >}}) ;
- `coder@vscode-824991-64744dd6d8-zbgv5` : le nom de l'utilisateur (ici `coder`) et le nom de la machine (ici, un conteneur, notion que l'on verra là encore dans le chapitre sur la [portabilité]({{< ref "/content/portability.md" >}}))
- `~/work` : le chemin du répertoire courant, i.e. à partir duquel va être lancée toute commande.

Afin de bien comprendre les notions de chemin et de répertoire courant, intéressons nous d'abord au fonctionnement d'un *filesystem*.

## Notions de *filesystem*

Le terme *filesystem* (système de fichiers) désigne la manière dont sont organisés les fichiers au sein d'un système d'exploitation. Cette structure est hiérarchique, en forme d'arbre :
- elle part d'un répertoire racine (le dossier qui contient tous les autres) ;
- contient des dossiers ;
- les dossiers peuvent contenir à leur tout des dossiers (sous-dossiers) ou des fichiers.

Intéressons nous à la structure du *filesystem* Linux standard.

[<img src="/linux_fs.jpg" height="300"/>](/linux_fs.jpg)

Source : [commons.wikimedia.org](https://commons.wikimedia.org/wiki/File:Linux_file_system_foto_no_exif_(1).jpg)

Quelques observations :
- la racine (*root*) sur Linux s'appelle `/`, là où elle s'appelle `C:\` par défaut sur Windows ;
- le répertoire racine contient un ensemble de sous-dossiers, dont la plupart ont un rôle essentiellement technique. Il est tout de même utile d'en décrire les principaux :
  - `/bin` : contient les binaires, i.e. les programmes exécutables ;
  - `/etc` : contient les fichiers de configuration ;
  - `/home` : contient l'ensemble des dossiers et fichiers personnels des différents utilisateurs. Chaque utilisateur a un répertoire dit "HOME" qui a pour chemin `/home/<username>` Ce répertoire est souvent représenté par le symbole `~`. C'était notamment le cas dans l'illustration du terminal VSCode ci-dessus, ce qui signifie qu'on se trouvait formellement dans le répertoire `/home/coder/work`, `coder` étant l'utilisateur par défaut du service VSCode sur le SSP Cloud.

Chaque dossier ou fichier est représenté par un chemin d'accès, qui correspond simplement à sa position dans le *filesystem*. Il existe deux moyens de spécifier un chemin :
- en utilisant un chemin **absolu**, c'est à dire en indiquant le chemin complet du dossier ou fichier depuis la racine. En Linux, on reconnaît donc un chemin absolu par le fait qu'il commence forcément par `/`.
- en utilisant un chemin **relatif**, c'est à dire en indiquant le chemin du dossier ou fichier *relativement* au répertoire courant.

Comme tout ce qui touche de près ou de loin au terminal, la seule manière de bien comprendre ces notions est de les appliquer. Les exercices de fin de chapitre vous permettront d'appliquer ces concepts à des cas pratiques.

## Lancer des commandes

Le rôle d'un terminal est de lancer des commandes. Ces commandes peuvent être classées en trois grandes catégories : 
- navigation au sein du *filesystem* 
- manipulations du *filesystem* (créer, lire, modifier des dossiers/fichiers)
- lancement de programmes

### Navigation au sein du *filesystem*

Lorsqu'on lance un programme à partir du terminal, celui-ci a pour référence le répertoire courant dans lequel on se trouve au moment du lancement. Par exemple, si l'on exécute un script Python en se trouvant dans un certain répertoire, tous les chemins des fichiers utilisés dans le script seront relatifs au répertoire courant d'exécution — à moins d'utiliser uniquement des chemins absolus, ce qui n'est pas une bonne pratique en termes de reproductibilité puisque cela lie votre projet à la structure de votre *filesystem* particulier.

Ainsi, la très grande majorité des opérations que l'on est amené à réaliser dans un terminal consiste simplement à se déplacer au sein du *filesystem*. Les trois commandes suivantes sont donc essentielles, il faut les pratiquer jusqu'à ce qu'elles deviennent une seconde nature.

| Commande                          | Description                                                     |
|-----------------------------------|-----------------------------------------------------------------|
| **pwd**                             | afficher (Print Working Directory) le chemin (absolu) du dossier courant |
| **cd chemin**                       | changer (Change Directory) de dossier courant                   |
| **ls**                              | lister les fichiers dans le dossier courant                     |

La commande `cd` accepte aussi bien des chemins absolus que des chemins relatifs. En pratique, il est assez pénible de manipuler des chemins absolus, qui peuvent facilement être très longs. On utilisera donc essentiellement des chemins relatifs, ce qui revient à se déplacer à partir du répertoire courant. Pour se faire, voici quelques utilisations très fréquentes de la commande `cd`.

| Commande                          | Description                                                     |
|-----------------------------------|-----------------------------------------------------------------|
| **cd ..**                             | remonter d'un niveau dans l'arborescence (dossier parent) |
| **cd ~**                       | revenir dans le répertoire HOME de l'utilisateur courant               |

La première commande est l'occasion de revenir sur une convention d'écriture importante pour les chemins relatifs :
- `.` représente le répertoire courant. Ainsi, `cd .` revient à changer de répertoire courant... pour le répertoire courant, ce qui bien sûr ne change rien. Mais le `.` est très utile pour le lancement de programmes, notamment lorsque l'on souhaite spécifier qu'un programme doit s'exécuter dans le répertoire courant ;
- `..` représente le répertoire parent du répertoire courant.

### Lancement de programmes


## Variables d'environnement

## Permissions

- root / user
- sudo

## Gestionnaire de paquets

- Principe / différence avec Windows
- Distributions Linux
- Présentation d'apt
- apt install
- apt update

## Tricks

- autocomplétion

# Application

- installer et utiliser tree pour explorer le filessytem
- faire trouver des informations dans un projet template
- faire installer Python
- lancer un script Python avec des paramètres à partir du terminal
- faire installer un package qui nécessite sudo
- faire installer un package Python qui nécessite des librairies systèmes, à installer via apt

