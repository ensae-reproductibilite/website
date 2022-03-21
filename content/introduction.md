---
title: "Introduction"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---




# Les bonnes pratiques de développement

## Origines
  
## Pourquoi s'intéresser aux bonnes pratiques ?

## Public visé

Ce cours s'adresse à des data scientists. L'objectif n'est pas d'acquérir des compétences techniques pointues dans des domaines comme l'infrastructure informatique, l'administration de serveurs, la mise en production et la maintenance de *pipelines* de données, ou encore le développement applicatif. Ces compétences font l'objet de métiers à part entière, que sont respectivement les *data architects*, les *sysadmin*, les *data engineers* et les développeurs. 

En revanche, face à la taille croissante des projets de *data science* et donc des équipes qui les portent, le *data scientist* tend à se retrouver à l'interface de ces différentes professions, avec lesquelles il doit communiquer de manière efficiente pour mener ces projets à bien. Ce cours vise à fournir, plus qu'une compétence technique pointue, les élements de langage nécessaires pour pouvoir jouer ce rôle d'interface en communiquant à la fois avec les équipes métiers et les équipes techniques qui entourent un projet de *data science*. 

### Le code comme outil de communication
        
- pour soi dans le futur
- pour les autres
        
### L'enjeu majeur de la reproductibilité

### Préalable à la mise en production

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


# Approche pédagogique

## Apprentissage par la pratique

- Application des concepts dès le début sur projets personnels

## Langages

Les principes présentés dans ce cours sont pour la plupart agnostiques du langage de programmation utilisé. Ce choix n'est pas qu'éditorial, c'est selon nous un aspect fondamental du sujet des bonnes pratiques. Trop souvent, des différences de langage entre les phases de développement (ex : R, Python) et de mise en production (ex : Java) érigent des murs artificiels qui réduisent fortement la capacité à valoriser des projets de *data science*. A l'inverse, plus les différentes équipes qui forment le cycle de vie d'un projet s'accorderont pour appliquer le même ensemble de bonnes pratiques, plus ces équipes développeront un langage commun, et plus les déploiements seront facilités. Un exemple parlant est l'utilisation de la conteneurisation : si le *data scientist* met à disposition une image `Docker` comme *output* de sa phase de développement et que le *data engineer* s'occupe de déployer cette image sur une infrastructure dédiée, le contenu même de l'application en termes de langage importe finalement assez peu. Cet exemple, certes simpliste, illustre malgré tout l'enjeu des bonnes pratiques en matière de communication au sein d'un projet.

Les exemples présentés dans ce cours seront pour l'essentiel en `Python` et en `R`. La principale raison et que ces langages sont enseignés dans la majorité des cursus de *data science*. Encore une fois, il est tout à fait possible d'appliquer les mêmes principes avec d'autres langages, et nous encorageons les étudiants à s'essayer à cet exercice formateur.

## Environnement d'exécution

A l'instar du langage, les principes appliqués dans ce cours sont agnostiques à l'infrastructure utilisée pour faire tourner les exemples proposés. Il est donc à la fois possible et souhaitable d'appliquer les bonnes pratiques aussi bien à un projet individuel développé sur un ordinateur personnel qu'à un projet collaboratif visant à être déployé sur une infrastructure de production dédiée.

Cependant, nous choisissons comme environnement de référence tout au long de ce cours le [SSP Cloud](https://datalab.sspcloud.fr/home), une plateforme de services pour la *data science* développée à l'Insee et accessible aux élèves des écoles statistiques. Les raisons de ce choix sont multiples :
- l'environnement de développement est normalisé : les serveurs du SSP Cloud ont une configuration homogène — notamment, ils se basent sur une même distribution Linux (Debian) —
- via un cluster Kubernetes sous-jacent, le SSP Cloud met à disposition une infrastructure robuste permettant le déploiement automatisé d'applications potentiellement intensives en données, ce qui permet de **simuler un véritable environnement de production** ;
- le SSP Cloud est construit selon les standards les plus récents des infrastructures *data science*, et permet donc d'**acquérir les bonnes pratiques de manière organique** :
  - les services sont lancés via des conteneurs, configurés par des images *Docker*. Cela permet de garantir une forte **reproductibilité** des déploiements, au prix d'une phase de développement un peu plus coûteuse ;
  - le SSP Cloud est basé sur une approche dite *cloud native* : il est construit sur un ensemble modulaire de briques logicielles, qui permettent d'appliquer une séparation nette du code, des données, de la configuration et de l'environnement d'exécution, principe majeur des bonnes pratiques qui reviendra tout au long de ce cours.
