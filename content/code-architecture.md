---
  title: "Améliorer la qualité de son code et la structure de ses projets"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---
  
  
  
# Qualité du code 

## Principes généraux

### Lisibilité

- expressivité des nommages
- simplicité

### Cohérence interne

- importance des conventions, par projet et/ou communautaires

### Limiter la redondance

- utiliser des fonctions

### Documentation

- commentaires
- docstrings

## Standards communautaires de code

- R : tidyverse / Google style guides
- Python : PEP 8, PEP 257

## Outils

### Analyse de code

- linters
- formatters

### Relecture par un tiers / pair-programming



# Structure des projets

## Modularité

- fonctions
- modules

## Principes d'architecture

### Séparation données/code/config/environnement d'exécution

### Modèles

- input / traitement / output
- domain-driven design (data, domain, application, presentation)

### Templates

- R : RProjects
- Python : cookiescutter

## Packages

### Gestion des dépendances

### Documentation

### Logging

### Tests unitaires

### Publication

### Maintenance



# Application

Sur un projet personnel, terminé ou en cours : 
- utiliser un linter pour améliorer la qualité du code au maximum (seuil ?)
- modulariser le code
  - réécrire le code sous forme de fonctions
  - répartir les fonctions dans des modules thématiques
  - écrire un script `main.py` qui permet de reproduire le projet
- choisir une architecture cohérente de projet
- faire du projet un package
