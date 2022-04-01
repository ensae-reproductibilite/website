---
title: "Appliquer les concepts étudiés à un projet de data science"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---



L'objectif de cette mise en application est d'**illustrer les différentes étapes qui séparent la phase de développement d'un projet de celle de la mise en production**. Elle permettra de mettre en pratique les différents concepts présentés tout au long du cours.

Nous nous plaçons dans une situation initiale correspondant à la fin de la phase de développement d'un projet de data science. On a un notebook un peu monolithique, qui réalise les étapes classiques d'un *pipeline* de *machine learning* :
- import de données
- statistiques descriptives et visualisations
- *feature engineering*
- entraînement d'un modèle
- évaluation du modèle

**L'objectif est d'améliorer le projet de manière incrémentale jusqu'à pouvoir le mettre en production, en le valorisant sous une forme adaptée.** 

{{% box status="warning" title="Warning" icon="fa fa-exclamation-triangle" %}}
Il est important de bien lire les consignes et d'y aller progressivement.
Certaines étapes peuvent être rapides, d'autres plus fastidieuses ;
certaines être assez guidées, d'autres vous laisser plus de liberté.
Si vous n'effectuez pas une étape, vous risquez de ne pas pouvoir passer à
l'étape suivante qui en dépend.

Bien que l'exercice soit applicable sur toute configuration bien faite, nous 
recommandons de privilégier l'utilisation du [SSP Cloud](https://datalab.sspcloud.fr/home), où tous les 
outils nécessaires sont pré-installés et pré-configurés. 
{{% /box %}}




# Partie 1 : application des bonnes pratiques

Cette première partie vise à **rendre le projet conforme aux bonnes pratiques** présentées dans le cours. Elle fait intervenir les notions suivantes : 
- utilisation du **terminal**
- **qualité du code**
- **architecture de projets**
- **contrôle de version** avec Git
- **travail collaboratif** avec Git et GitHub

Le plan de la partie est le suivant :

0. :zero: Forker le dépôt et créer une branche de travail.
1. :one: S'assurer que le notebook s'exécute correctement.
2. :two: Mettre en fonctions les parties importantes de l'analyse (import des données, feature engineering, entraînement et évaluation du modèle) et mettre ces fonctions dans un module `functions.py`.
3. :three:  Créer un script `main.py` qui reproduit l'analyse de bout en bout sans passer par un notebook.
4. :four:  Appliquer les recommendations du linter `PyLint` aux scripts `main.py` et `functions.py`, viser une note minimale de 9/10 pour le premier et 6/10 pour le second.
5. :five: S'inspirer du template de projet [cookiecutter datascience](https://drivendata.github.io/cookiecutter-data-science/) pour construire une structure de package.
6. :six: Exporter l'environnement Conda pour favoriser la portabilité du projet.
7. :seven: Mettre les données dans son bucket personnel sur le stockage MinIO du SSP Cloud et adapter la fonction d'import de données. Supprimer les fichiers `train.csv` et `test.csv` du dépôt Git.
8. :eight: Nettoyer le projet Git d'éventuels fichiers/dossiers indésirables (ex : les dossiers __pycache__) et ajouter le [fichier .gitignore adapté à Python](https://github.com/github/gitignore/blob/main/Python.gitignore) à la racine du projet. Ajouter le dossier `data/` au `.gitignore` pour éviter tout versioning de données.
9. :nine: Ouvrir une *pull request* sur le dépôt du projet.



## Etape 0: forker le dépôt d'exemple et créer une branche de travail

- Ouvrir un service `vscode` sur le [SSP Cloud](https://datalab.sspcloud.fr/home). Vous pouvez aller
dans la page `My Services` et cliquer sur `New service`. Sinon, vous
pouvez lancer le service en cliquant directement [ici](https://datalab.sspcloud.fr/launcher/inseefrlab-helm-charts-datascience/vscode?autoLaunch=false).

- Générer un jeton d'accès (*token*) sur GitHub afin de permettre l'authentification en ligne de commande à votre compte. La procédure est décrite [ici](https://docs.sspcloud.fr/onyxia-guide/controle-de-version#creer-un-jeton-dacces-token). Garder le jeton généré de côté.

- Forker le dépôt `Github` <i class="fab fa-github"></i> https://github.com/avouacr/ensae-reproductibilite-projet

- Clôner __votre__ dépôt `Github` <i class="fab fa-github"></i> en utilisant le
terminal depuis `Visual Studio` (`Terminal > New Terminal`) :

```shell
$ git clone https://<TOKEN>@github.com/avouacr/ensae-reproductibilite-projet.git
```

où `<TOKEN>` est à remplacer par le jeton que vous avez généré précédemment.

- Se placer avec le terminal dans le dossier en question : 

```shell
$ cd ensae-reproductibilite-projet
```

- Créez une branche `nettoyage` :

```shell
$ git checkout -b nettoyage
Switched to a new branch 'nettoyage'
```

## Etape 1 : s'assurer que le notebook s'exécute correctement

La première étape est simple, mais souvent oubliée : vérifier que le code fonctionne correctement. 

- Ouvrir dans VSCode le notebook `titanic.ipynb`, et choisir comme kernel `basesspcloud`
- Exécuter le notebook en entier pour vérifier s'il fonctionne
- Corriger l'erreur qui empêche la bonne exécution.

Il est maintenant temps de *commit* les changements effectués avec Git :

```shell
git add titanic.ipynb
git commit -m "Corrige l'erreur qui empêchait l'exécution"
git push
```

Essayez de *commit* vos changements à chaque étape de l'exercice, c'est une bonne habitude à prendre.


# Partie 2 : construction d'un projet portable et reproductible

# Partie 3 : mise en production
