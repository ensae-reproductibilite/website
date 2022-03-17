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
- le [SSP Cloud](https://datalab.sspcloud.fr). Dans la mesure où les exemples de mise en production du cours seront illustrées sur cet environnement, nous recommendons de l'utiliser dès à présent pour bien se familiariser.

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
- Distributions Linux
- Présentation d'apt
- apt install
- apt update



# Application

- faire trouver des informations dans un projet template
- faire installer Python
- lancer un script Python avec des paramètres à partir du terminal
- faire installer un package qui nécessite sudo
- faire installer un package Python qui nécessite des librairies systèmes, à installer via apt

