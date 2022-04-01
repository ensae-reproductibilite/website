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
1. :one: S'assurer que le notebook `titanic.ipynb` s'exécute correctement.
2. :two: Mettre en fonctions les parties importantes de l'analyse (import des données, feature engineering, entraînement et évaluation du modèle) et mettre ces fonctions dans un module `functions.py`.
3. :three:  Créer un script `main.py` qui reproduit l'analyse de bout en bout sans passer par un notebook.
4. :four:  Appliquer les recommendations du linter `PyLint` aux scripts `main.py` et `functions.py`, viser une note minimale de 9/10 pour le premier et 6/10 pour le second.
5. :five: S'inspirer du template de projet [cookiecutter datascience](https://drivendata.github.io/cookiecutter-data-science/) pour construire une structure de package.
6. :six: Exporter l'environnement Conda pour favoriser la portabilité du projet.
7. :seven: Mettre les données dans son bucket personnel sur le stockage MinIO du SSP Cloud et adapter la fonction d'import de données. Supprimer les fichiers `train.csv` et `test.csv` du dépôt Git.
8. :eight: Nettoyer le projet Git d'éventuels fichiers/dossiers indésirables (ex : les dossiers __pycache__) et ajouter le [fichier .gitignore adapté à Python](https://github.com/github/gitignore/blob/main/Python.gitignore) à la racine du projet. Ajouter le dossier `data/` au `.gitignore` pour éviter tout versioning de données.
9. :nine: Ouvrir une *pull request* sur le dépôt du projet.



## Etape 0: forker et clôner le modèle d'exemple

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


# Partie 2 : construction d'un projet portable et reproductible

# Partie 3 : mise en production
