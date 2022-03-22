---
title: "Versionner son code et travailler collaborativement avec Git"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---
  

# Le contrôle de version

## Pourquoi faire ?

Le développement rapide de la *data science* au cours de ces dernières années s'est accompagnée d'une complexification substantielle des projets. Par ailleurs, les projets sont de plus en plus collaboratifs, que ce soit dans le cadre d'équipes dans un contexte professionnel ou bien pour des contributions à des projets open-source. Naturellement, ces évolutions doivent nous amener à modifier nos manières de travailler pour gérer cette complexité croissante et continuer à produire de la valeur à partir des projets de *data science*.

Pourtant, tout *data scientist* s'est parfois demandé :

- quelle était la bonne version d'un programme 
- qui était l'auteur d'un bout de code en particulier
- si un changement était important ou juste un essai
- comment fusionner des programmes
- etc.

Et il n'est pas rare de perdre le fil des versions de son projet lorsque l'on garde trace de celles-ci de façon manuelle.

**Exemple de contrôle de version fait "à la main"**
![](/fichiers_multiples.png)

Pourtant, il existe un outil informatique puissant afin de répondre à tous ces besoins : la gestion de version (*version control system* (VCS) en anglais). Ses avantages sont incontestables et permettent de facilement :

- enregistrer l'historique des modifications d'un ensemble de fichiers 
- revenir à des versions précédentes d'un ou plusieurs fichiers
- rechercher les modifications qui ont pu créer des erreurs
- travailler simultanément sur un même fichier sans risque de perte
- partager ses modifications et récupérer celles des autres
- proposer des modifications, les discuter, sans pour autant modifier la dernière version existante
- identifier les auteurs et la date des modifications

En outre, ces outils fonctionnent avec tous les langages informatiques car ils reposent sur la comparaison des lignes et des caractères des programmes, indépendamment du langage. En bref, c'est la bonne manière pour partager des codes et travailler à plusieurs sur un projet de *data science*. En réalité, il ne serait pas exagéré de dire que **l'utilisation du contrôle de version est la bonne pratique la plus fondamentale de tout projet faisant intervenir du code**, et qu'elle conditionne largement toutes les autres.

## Git

Plusieurs logiciels de contrôle de version existent sur le marché. En principe, le logiciel Git, développé initialement pour fournir une solution décentralisée et *open-source* dans le cadre du développement du noyau Linux, est devenu largement hégémonique. Aussi, **toutes les application de ce cours s'effectueront à l'aide du logiciel Git**.

## GitHub

Travailler de manière collaborative avec Git implique de synchroniser son répertoire local avec une copie distante, située sur un serveur hébergeant des projets Git. Ce serveur peut être un serveur interne à une organisation, ou bien être fourni par un hébergeur externe. Les deux alternatives les plus populaires en la matière sont GitHub et GitLab. Dans ce cours, **nous utiliserons GitHub, qui est devenu au fil des années la référence pour l'hébergement des projets open-source**. En pratique, les deux services sont relativement semblables, et tous les concepts présentés se retrouvent sous une forme similaire sur les deux plateformes.

# Des bases de Git

Ce cours part du principe que les lecteurs sont déjà familiers avec l'utilisation de Git, au travers de projets individuels ou collectifs. Aussi, nous rappelons dans cette section les notions essentielles de Git, mais nous ne présenterons pas leur implémentation pratique. Le lecteur souhaitant un rappel plus complet peut par exemple se référer à la [formation au travail collaboratif avec Git et RStudio](https://collaboratif-git-formation-insee.netlify.app/index.html) donnée à l'Insee, dont sont issues de nombreuses ressources utilisées dans ce chapitre.

## Principes

Le graphique suivant illustre les principes fondamentaux de Git.

**Git tout-en-un** ([Source](http://fabacademy.org/2021/labs/bhubaneswar/students/deepak-chaudhry/ia_PPFP.html))
![](/gitallinone.png)

Lorsqu'on utilise Git, il est important de **bien distinguer ce qui se passe en local** (sur son poste, sur le serveur sur lequel on travaille...) **de ce qui se passe en *remote***, i.e. en intéragissant avec un serveur distant. Comme le montre le graphique, l'essentiel du contrôle de version se passe en réalité en local. 

En théorie, sur un projet individuel, il est même possible de réaliser l'ensemble du contrôle de version en mode hors-ligne. Pour cela, il suffit d'indiquer à Git le projet (dossier) que l'on souhaite versionner en utilisant la commande `git init`. Cette commande a pour effet de créer un dossier `.git` à la racine du projet, dans lequel Git va stocker tout l'historique du projet (commits, branches, etc.) et permettre de naviguer entre les versions. A cause du `.` qui préfixe son nom, ce dossier est généralement caché par défaut, ce qui n'est pas problématique dans la mesure où il n'y a jamais besoin de le parcourir ou de le modifier à la main en pratique. Retenez simplement que **c'est la présence de ce dossier `.git` qui fait qu'un dossier est considéré comme un projet Git**, et donc que vous pouvez utilisez les commandes de Git dans ce dossier à l'aide d'un terminal. 

En pratique, travailler uniquement en local n'est pas très intéressant. Pour pouvoir travailler de manière collaborative, on va vouloir **synchroniser les différentes copies locales du projet à un répertoire centralisé**, qui maintient de fait la "source de vérité" (*single source of truth*). Même sur un projet individuel, il fait sens de synchroniser son répertoire local à une copie distante pour assurer l'intégrité du code de son projet en cas de problème matériel.

En général, on va donc initialiser le projet dans l'autre sens :
- créer un nouveau projet sur GitHub
- générer un jeton d'accès (*personal access token*)
- cloner le projet en local via la méthode HTTPS : `git clone https://github.com/<username>/<project_name>.git`

Le projet cloné est un projet Git — il contient le dossier `.git` — synchronisé par défaut avec le répertoire distant. On peut le vérifier avec la commande `remote` de Git :

```bash
$ git remote -v
origin  https://github.com/linogaliana/ensae-reproductibilite-website.git (fetch)
origin  https://github.com/linogaliana/ensae-reproductibilite-website.git (push)
```

Le projet local est bien lié au répertoire distant sur GitHub, auquel Git donne par défaut le nom `origin`. Cette synchronisation permet d'utiliser les commandes classiques : 
- `git pull` : récupérer les changements (*fetch*) sur le *remote* et les appliquer au projet local
- `git push` : envoyer les changements locaux sur le *remote*


## En pratique

Git est un logiciel, qui peut être téléchargé sur le [site officiel](https://git-scm.com/downloads) pour différents systèmes d'exploitation. Il existe cependant différentes manières d'utiliser Git :
- le **client en ligne de commande** : c'est l'implémentation standard, et donc la plus complète. C'est celle qu'on utilisera dans ce cours. Le client Git est installé par défaut sur les différents services du SSP Cloud (VSCode, RStudio, Jupyter, etc.) et peut donc être utilisé via n'importe quel terminal. La [documentation](https://docs.sspcloud.fr/onyxia-guide/controle-de-version) du SSP Cloud détaille la procédure ;
- des **interfaces graphiques** : elles facilitent la prise en main de Git via des guides visuels, mais ne permettent pas de réaliser toutes les opérations permises par Git
  - l'interface native de `RStudio` pour les utilisateurs de `R` : très complète et stable. La [formation au travail collaboratif avec Git et RStudio](https://collaboratif-git-formation-insee.netlify.app/index.html) présente son utilisation de manière détaillée ;
  - le plugin `Jupyter-git` pour les utilisateurs de `Python` : elle implémente les principales *features* de Git, mais s'avère assez instable à l'usage.



# Organiser le travail collaboratif

## Principes

- Branches
- Gestion des conflits de version
- Worflows (focus : GH flow)
- Droits d'accès
- Fork

## Outils collaboratifs

- Issues
- Pull Requests

## Contributions à des projets open-source

- via Fork + PR
- suivre les règles de contribution du projet




# Bonnes pratiques de Git


# Application

- individuel
  - exercice guidé add/commit/push/pull/checkout
  - mise sur GitHub d'un projet personnel
- collaboratif
  - cadavre exquis
  - PR à partir d'un fork
