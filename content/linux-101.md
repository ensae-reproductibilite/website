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

- Git CLI : les interfaces graphiques sont parfois limitées
- Image Docker => commandes Linux
- Mise en prod => interagir avec un serveur distant, sur Linux dans > 99 % des cas
- Généralement : meilleure compréhension du fonctionnement d'un système de fichiers et des processus => autonomie ++

## Environnement de travail

- Recommandé : terminal du service VSCode sur le SSP Cloud
- Autre option sur Linux : [Katacoda](https://katacoda.com/scenario-examples/courses/environment-usages/ubuntu-2004), un bac à sable dans un système Ubuntu
- Sur Windows : git bash (émulation minimaliste d'un terminal Linux)

## Notions de filesystem

- structure d'arbre
- chemins absolus/relatifs
- notion de HOME, dépendante de l'OS

## Notions de terminal

- commande et paramètres
- autocomplétion
- pwd
- ls
- cd (move up, down, get back to home)
- mv
- cp
- mkdir
- cat

## Permissions

- root / user
- sudo

## Gestionnaire de paquets

- Principe / différence avec Windows
- Présentation d'apt
- apt install
- apt update



# Application

- faire trouver des informations dans un projet template
- faire installer Python
- lancer un script Python avec des paramètres à partir du terminal
- faire installer un package qui nécessite sudo
- faire installer un package Python qui nécessite des librairies systèmes, à installer via apt

