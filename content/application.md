---
title: "Appliquer les concepts présentés à un projet de data science"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---



L'objectif de cette mise en application est d'illustrer comment, en
pratique, s'organise une mise au propre d'un code où il y a 
eu du laisser-aller.

Nous allons nous placer dans la situation où on a un _notebook_
qui mélange de nombreuses étapes de traitement de données. 
Le nettoyage va se faire progressivement. Chaque exercice va
représenter une étape du nettoyage et sera identifiée par 
un `tag` `Git`. Cela permettra dans le futur de bien voir
les évolutions à chaque étape et facilement comparer l'état
du projet entre deux instants

{{% box status="warning" title="Warning" icon="fa fa-exclamation-triangle" %}}
Il est important de bien lire les consignes et d'y aller progressivement.
Certaines étapes peuvent être rapides, d'autres plus fastidieuses ;
certaines être assez guidées, d'autres vous laisser plus de liberté.
Si vous n'effectuez pas une étape, vous risquez de ne pas pouvoir passer à
l'étape suivante qui en dépend.

Bien que l'exercice soit applicable sur toute configuration bien faite, nous 
recommandons de privilégier l'utilisation du `SSP Cloud` où tous les 
outils sont pré-installés et pré-configurés. 
{{% /box %}}

Le plan général est le suivant :

0. :zero: Forker le dépôt et créer une branche de travail.
1. :one: S'assurer que le notebook `titanic.ipynb` s'exécute correctement.
2. :two: Mettre en fonctions les parties importantes de l'analyse (import des données, feature engineering, entraînement et évaluation du modèle) et mettre ces fonctions dans un module `functions.py`.
3. :three:  Créer un script `main.py` qui reproduit l'analyse de bout en bout sans passer par un notebook.
4. :four:  Appliquer les recommendations du linter `PyLint` aux scripts `main.py` et `functions.py`, viser une note minimale de 9/10 pour le premier et 6/10 pour le second.
5. :five: S'inspirer du template de projet [cookiecutter datascience](https://drivendata.github.io/cookiecutter-data-science/) pour construire une structure de package.
6. :six: Exporter l'environnement Conda pour favoriser la portabilité du projet.
7. :seven: Mettre les données dans son bucket personnel sur le stockage MinIO du SSP Cloud et adapter la fonction d'import de données. Supprimer les fichiers `train.csv` et `test.csv` du dépôt Git.
8. :eight: Nettoyer le projet Git d'éventuels fichiers/dossiers indésirables (ex : les dossiers __pycache__) et ajouter le [fichier .gitignore adapté à Python](https://github.com/github/gitignore/blob/main/Python.gitignore) à la racine du projet. Ajouter le dossier `data/` au `.gitignore` pour éviter tout versioning de données.



## Etape 1: forker et clôner le modèle d'exemple

Le dépôt est disponible sur `Github` <i class="fab fa-github"></i>
à l'adresse
https://github.com/avouacr/ensae-reproductibilite-projet


{{% box status="exercise" title="Exercice préliminaire" icon="fa fa-rocket" %}}

- Ouvrir un service `vscode` sur le `SSP Cloud`. Vous pouvez aller
dans la page `My Services` et cliquer sur `New service`. Sinon, vous
pouvez cliquer
[directement par ce lien](https://datalab.sspcloud.fr/launcher/inseefrlab-helm-charts-datascience/vscode?autoLaunch=false)

- Forker le dépôt `Github` <i class="fab fa-github"></i> https://github.com/avouacr/ensae-reproductibilite-projet

- Clôner __votre__ dépôt `Github` <i class="fab fa-github"></i> en utilisant le
terminal depuis `Visual Studio` (`Terminal > New Terminal`).
Pour rappel, la commande est

```shell
git clone URL_DEPOT_GIT
```

où `URL_DEPOT_GIT` est l'adresse que vous avez copier-coller depuis le bouton
clône de `Github`
(normalement de la forme
`https://github.com/<USERNAME_GITHUB>/ensae-reproductibilite-projet.git`)

- Se placer dans le terminal dans le dossier en question. 

```shell
cd ensae-reproductibilite-projet
```

- Créez une branche `nettoyage`. Pour rappel, la commande est

```shell
git checkout -b nettoyage
#Switched to a new branch 'nettoyage'
```


- Si vous ne l'avez pas déjà fait avant, créez un _token_ `Github` et 
conservez le à portée de main (dans un fichier texte ou dans un gestionnaire
de mot de passe)

{{% /box %}}
