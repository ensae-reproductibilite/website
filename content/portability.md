---
title: "Rendre son projet de data science portable et reproductible"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---



# Environnements d'exécution

- Exemples illustratifs de problèmes liés à la non-normalisation de son environnement d'exécution

## Principes du développement logiciel pour favoriser la reproductibilité

- Isolation
- Portabilité

## Gestion des dépendances

- Dépendances dans le langage du projet
- Dépendances dans d'autres langage
- Adhérence à l'OS d'exécution (librairies, package manager...)
- Conflits de version (interpréteur, dépendances, librairies)

## Outils pour améliorer la portabilité

### Packages

- Principes
- Avantages
  - Modularité
  - Gestion des dépendances
  - Simplicité
- Limites
  - Gestion des dépendances spécifiques au langage du projet => portabilité limitée
  - Peu d'isolation
- Implémentations
  - R
  - Python

### Environnements virtuels

- Principes
- Avantages
  - Isolation du projet
  - Relative simplicité d'utilisation
- Limites
  - Gestion des dépendances spécifiques au langage du projet => portabilité limitée
- Implémentations
  - R : renv
  - Python : venv, conda, poetry

### Conteneurisation

- Principes
- Avantages
  - Isolation complète du projet (toutes dépendances, librairies externes, OS d'exécution...)
  - Portabilité totale
- Limites
  - Rend la phase de développement un peu lourde
- Implémentations
  - Docker
