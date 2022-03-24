---
title: "Introduction"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---



# Vue d'ensemble

Ce cours s'adresse aux praticiens de la *data science*, entendue ici au sens large comme la combinaison de techniques issues des mathématiques, de la statistique et de l'informatique pour produire de la connaissance utile à partir de données. Cela inclut donc tout autant les *data scientists* travaillant dans le privé ou dans des administrations que les chercheurs dont les travaux font intervenir des traitements computationnels à partir de données.

Il part du constat que les formations académiques dans ce domaine adoptent souvent une orientation essentiellement technique, visant une compréhension fine des modèles manipulés, mais ne discutent que rarement des problèmes pratiques qui forment le quotidien du *data scientist* dans un contexte professionnel. Ce cours vise à combler ce manque en proposant des pistes de solution à diverses questions que peuvent se poser les *data scientists* lorsqu'ils transitionnent du contexte de la formation initiale à des projets réels :
- comment travailler de manière collaborative sur un projet ?
- comment partager du code et s'assurer que celui-ci va tourner sans erreur sur un autre environnement d'exécution ?
- comment passer d'un environnement de développement — par exemple, des notebooks — à un environnement de production — comme un serveur de production ou bien un *cluster* ?
- comment déployer un modèle de *data science*, et rendre celui-ci accessible à des utilisateurs afin de le valoriser ?
- comment automatiser les différentes étapes de son projet afin de simplifier sa maintenance ?

Afin de proposer des réponses à ces interrogations, ce cours présente **un ensemble de bonnes pratiques et d'outils issus de différents domaines de l'informatique**, comme le développement logiciel, l'infrastructure, l'administration de serveurs, le déploiement applicatif, etc.. L'objectif n'est bien entendu pas de développer une expertise dans chacun de ces domaines, dans la mesure où ces compétences font l'objet de métiers à part entière, que sont les développeurs, les *data architects*, les *sysadmin*, ou encore les *data engineers*. 

En revanche, face à la taille croissante des projets de *data science* et donc des équipes qui les portent, le *data scientist* tend à se retrouver à l'interface de ces différentes professions, avec lesquelles il doit communiquer de manière efficiente pour mener ces projets à bien. **Ce cours vise à fournir, plus que des connaissances techniques pointues, les élements de langage nécessaires pour pouvoir jouer ce rôle d'interface en communiquant à la fois avec les équipes métiers et les équipes techniques qui entourent un projet de *data science***.




# Les bonnes pratiques de développement

## Origine

La notion de "bonnes pratiques" qui nous intéresse dans ce cours trouve son origine au sein de la communauté des développeurs logiciels. Elle constitue une réponse à plusieurs constats :
- le code est beaucoup plus souvent lu qu'il n'est écrit ;
- la maintenance d'un code demande souvent (beaucoup) plus de ressources que son développement initial ;
- la personne qui maintient une base de code a de fortes chances de ne pas être celle qui l'a écrite.

Face à ces constats, un **ensemble de règles informelles** ont été conventionnellement acceptées par la communauté des développeurs comme **produisant des logiciels plus fiables, évolutifs et maintenables dans le temps**. Récemment, dans le contexte d'une évolution des logiciels vers des applications web vivant dans le *cloud*, un certain nombre de ces bonnes pratiques ont été formalisées dans un manifeste : la [12-factor app](https://12factor.net/fr/).

## Pourquoi s'intéresser aux bonnes pratiques ?

Tout cela est bien intéressant, mais en quoi est-ce pertinent pour le *data scientist*, dont le rôle n'est pas de développer des applications mais de donner du sens aux données ? Notre sentiment est que, du fait du développement rapide de la *data science* et conséquemment de la croissance de la taille moyenne des projets, l'activité du *data scientist* tend à se rapprocher par certains aspects de celle du développeur :
- les analyses de *data science* sont intenses en code ;
- il doit travailler de manière collaborative au sein de projets de grande envergure ;
- il est de plus en plus amené à travailler à partir de données massives, ce qui nécessite de travailler sur des infrastructures *big data* informatiquement complexes ;
- il est amené à interagir avec des profils informatiques pour déployer ses modèles et les rendre accessible à des utilisateurs.

Aussi, il fait sens pour le *data scientist* moderne de s'intéresser aux bonnes pratiques en vigueur dans la communauté des développeurs. Bien entendu, celles-ci doivent être adaptées aux spécificités des projets basés sur des données. 

### Le code comme outil de communication
        
- pour soi dans le futur
- pour les autres
        
### L'enjeu majeur de la reproductibilité

### Déploiement et automatisation

## Un continuum de bonnes pratiques

### Comment fixer le bon niveau ?
            
- Ambitions du projet (état de l'existant, potentiel évolutif, potentiel collaboratif)
- Ressources (moyens humain, temps, existence d'une communauté de contributeurs)
- Contraintes (échéance, niveau de qualité attendu, mise en production, environnement d'exécution, enjeux de sécurité)

### Un socle minimal pour les projets de data science ?

- Standards de code
- Architecture de projet
- Git
- Gestion des dépendances

### Le bon curseur peut changer en fonction de l'évolution du projet

- Passage en production
- Projet open-source



# Modalités pratiques

## Approche pédagogique

Le parti pris de ce cours est que seule la pratique, et en particulier la confrontation à des problèmes issus de projets réels, permet d'acquérir efficacement des concepts informatiques. Aussi, une large part du cours consistera en l'application des notions étudiées à des cas concrets. Chaque chapitre

<!--Ce site doit être vu comme une base documentaire : il couvre une large variété de sujets liés aux bonnes pratiques de développement et à la mise en production, mais ne saurait prétendre à l'exhaustivité — aussi bien en termes d'étendue des sujets parcourus que de la profondeur avec laquelle chaque sujet est traité. Par ailleurs, comme nous l'avons vu précédemment, les bonnes pratiques doivent être comprises comme un continuum, sur lequel on vient se placer en fonction des caractéristiques du projet concerné. Aussi, il n'est pas souhaitable d'appliquer toutes
-->
## Langages

Les principes présentés dans ce cours sont pour la plupart agnostiques du langage de programmation utilisé. Ce choix n'est pas qu'éditorial, c'est selon nous un aspect fondamental du sujet des bonnes pratiques. Trop souvent, des différences de langage entre les phases de développement (ex : R, Python) et de mise en production (ex : Java) érigent des murs artificiels qui réduisent fortement la capacité à valoriser des projets de *data science*. A l'inverse, plus les différentes équipes qui forment le cycle de vie d'un projet s'accorderont pour appliquer le même ensemble de bonnes pratiques, plus ces équipes développeront un langage commun, et plus les déploiements seront facilités. Un exemple parlant est l'utilisation de la conteneurisation : si le *data scientist* met à disposition une image `Docker` comme *output* de sa phase de développement et que le *data engineer* s'occupe de déployer cette image sur une infrastructure dédiée, le contenu même de l'application en termes de langage importe finalement assez peu. Cet exemple, certes simpliste, illustre malgré tout l'enjeu des bonnes pratiques en matière de communication au sein d'un projet.

Les exemples présentés dans ce cours seront pour l'essentiel en `Python` et en `R`. La principale raison et que ces langages sont enseignés dans la majorité des cursus de *data science*. Encore une fois, il est tout à fait possible d'appliquer les mêmes principes avec d'autres langages, et nous encourageons les étudiants à s'essayer à cet exercice formateur.

## Environnement d'exécution

A l'instar du langage, les principes appliqués dans ce cours sont agnostiques à l'infrastructure utilisée pour faire tourner les exemples proposés. Il est donc à la fois possible et souhaitable d'appliquer les bonnes pratiques aussi bien à un projet individuel développé sur un ordinateur personnel qu'à un projet collaboratif visant à être déployé sur une infrastructure de production dédiée.

Cependant, nous choisissons comme environnement de référence tout au long de ce cours le [SSP Cloud](https://datalab.sspcloud.fr/home), une plateforme de services pour la *data science* développée à l'Insee et accessible aux élèves des écoles statistiques. Les raisons de ce choix sont multiples :
- **l'environnement de développement est normalisé** : les serveurs du SSP Cloud ont une configuration homogène — notamment, ils se basent sur une même distribution Linux (Debian) — ce qui garantit la reproductibilité des exemples présentés tout au long du cours ;
- via un cluster Kubernetes sous-jacent, le SSP Cloud met à disposition une infrastructure robuste permettant le déploiement automatisé d'applications potentiellement intensives en données, ce qui permet de **simuler un véritable environnement de production** ;
- le SSP Cloud est construit selon les standards les plus récents des infrastructures *data science*, et permet donc d'**acquérir les bonnes pratiques de manière organique** :
  - les services sont lancés via des conteneurs, configurés par des images *Docker*. Cela permet de garantir une forte **reproductibilité** des déploiements, au prix d'une phase de développement un peu plus coûteuse ;
  - le SSP Cloud est basé sur une **approche dite *cloud native*** : il est construit sur un ensemble modulaire de briques logicielles, qui permettent d'appliquer une séparation nette du code, des données, de la configuration et de l'environnement d'exécution, principe majeur des bonnes pratiques qui reviendra tout au long de ce cours.
