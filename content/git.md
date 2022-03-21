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

## GitHub


# Des bases de Git

## Pourquoi faire ?

- Stockage du code sur un serveur distant => perte impossible
- Historique complet des choix effectués tout au long du projet
- Possibilité de revenir à n'importe quelle version du projet
- Pratique du contrôle de version en vue d'un usage collaboratif
- Vitrine des projets effectués

## Principes

- local/remote/origin
- 3 zones de Git
- add/commit/push/pull
- checkout/log
- .gitignore

## En pratique

- Git est un logiciel
- CLI : git bash
- Outils graphiques
  - Intégration R Studio
  - Plugin Jupyter-git



# Organiser le travail collaboratif

## Pourquoi faire ?

- Tous les avantages de l'usage individuel dans un cadre collaboratif
- Git est distribué => multiple backups d'un projet
- Travail simultané sur les mêmes fichiers sans risque de perte
- Outil de référence dans l'environnement open-source

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



# Application

- individuel
  - exercice guidé add/commit/push/pull/checkout
  - mise sur GitHub d'un projet personnel
- collaboratif
  - cadavre exquis
  - PR à partir d'un fork
