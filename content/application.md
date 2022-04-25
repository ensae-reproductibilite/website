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

0. :zero: Forker le dépôt et créer une branche de travail
1. :one: S'assurer que le notebook s'exécute correctement
2. :two: Modularisation : mise en fonctions et mise en module
3. :three: Utiliser un `main` script
4. :four:  Appliquer les standards de qualité de code
5. :five: Adopter une architecture standardisée de projet
6. :six: Fixer l'environnement d'exécution
7. :seven: Stocker les données de manière externe
8. :eight: Nettoyer le projet Git
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

La première étape est simple, mais souvent oubliée : **vérifier que le code fonctionne correctement**. 

- Ouvrir dans VSCode le notebook `titanic.ipynb`, et choisir comme kernel `basesspcloud`
- Exécuter le notebook en entier pour vérifier s'il fonctionne
- Corriger l'erreur qui empêche la bonne exécution.

Il est maintenant temps de *commit* les changements effectués avec Git :

```shell
$ git add titanic.ipynb
$ git commit -m "Corrige l'erreur qui empêchait l'exécution"
$ git push
```

Essayez de *commit* vos changements à chaque étape de l'exercice, c'est une bonne habitude à prendre.

## Etape 2 : Modularisation - mise en fonctions et mise en module

Nous allons **mettre en fonctions les parties importantes de l'analyse, et les mettre dans un module afin de pouvoir les importer directement depuis le notebook**. En reformattant le code présent dans le notebook :

- créer une fonction qui importe les données d'entraînement (`train.csv`) et de test (`test.csv`) et renvoie des `DataFrames` pandas
- créer une (ou plusieurs) fonction(s) pour réaliser les étapes de *feature engineering*
- créer une fonction qui réalise le *split train/test* de validation
- créer une fonction qui entraîne et évalue un classifieur `RandomForest`, et qui prend en paramètre le nombre d'arbres (`n_estimators`). La fonction doit imprimer à la fin la performance obtenue et la matrice de confusion.
- mettre ces fonctions dans un module `functions.py`
- importer les fonctions via le module dans le notebook et vérifier que l'on retrouve bien les différents résultats en utilisant les fonctions.

{{% box status="warning" title="Warning" icon="fa fa-exclamation-triangle" %}}
Attention à bien **spécifier les dépendances** (packages à importer) dans le module pour que les fonctions puissent faire leur travail indépendamment du notebook !
{{% /box %}}

## Etape 3 : utiliser un `main` script

Fini le temps de l'expérimentation : on va maintenant essayer de se passer complètement du notebook. Pour cela, on va utiliser un `main` script, c'est à dire un script qui reproduit l'analyse en important et en exécutant les différentes fonctions dans l'ordre attendu.

- créer un script `main.py` (convention de nommage pour les `main` scripts en Python)
- importer les fonctions nécessaires à partir du module `functions.py`. Ne pas faire d' `import *`, ce n'est pas une bonne pratique ! Appeler les fonctions une par une en les séparant par des virgules
- programmer leur exécution dans l'ordre attendu dans le script
- vérifier que tout fonctionne bien en exécutant le `main` script à partir de l'exécutable Python :

```shell
$ python main.py
```

Si tout a correctement fonctionné, la performance du `RandomForest` et la matrice de confusion devraient s'afficher dans la console.

## Etape 4 : appliquer les standards de qualité de code

On va maintenant améliorer la qualité de notre code en appliquant les standards communautaires. Pour cela, on va utiliser le *linter* classique `PyLint`. 

Pour appliquer le linter à un script `.py`, la syntaxe à entrer dans le terminal est la suivante : 
```shell
$ pylint mon_script.py
```
Le linter renvoie alors une série d'irrégularités, en précisant à chaque fois la ligne de l'erreur et le message d'erreur associé (ex : mauvaise identation). Il renvoie finalement une note sur 10, qui estime la qualité du code à l'aune des standards communautaires (PEP8 et PEP257).

- appliquer une première fois le linter, respectivement aux scripts `functions.py` et `main.py`. Noter les notes obtenues.
- à partir des codes d'erreur, modifier le code pour résoudre les différents problèmes un par un
- viser une note minimale de 9/10 pour `main.py` et 6/10 pour `functions.py`.

{{% box status="tip" title="Note" icon="fa fa-hint" %}}
N'hésitez pas à taper un code d'erreur sur un moteur de recherche pour obtenir plus d'informations si jamais le message n'est pas clair !
{{% /box %}}

## Etape 5 : adopter une architecture standardisée de projet

On va maintenant modifier l'architecture de notre projet pour la rendre plus standardisée. Pour cela, on va utiliser le package *cookiecutter* qui génère des templates de projet. En particulier, on va choisir le [template datascience](https://drivendata.github.io/cookiecutter-data-science/) développé par la communauté pour s'inspirer de sa structure.

{{% box status="tip" title="Note" icon="fa fa-hint" %}}
L'idée de *cookiecutter* est de proposer des templates que l'on utilise pour initialiser un projet, afin de bâtir à l'avance une structure évolutive. La syntaxe à utiliser dans ce cas est la suivante : 
```shell
$ pip install cookiecutter
$ cookiecutter https://github.com/drivendata/cookiecutter-data-science
```

Ici, on a déjà un projet, on va donc faire les choses dans l'autre sens : on va s'inspirer de la structure proposée afin de réorganiser celle de notre projet selon les standards communautaires.
{{% /box %}}

- analyser et comprendre la [structure de projet](https://drivendata.github.io/cookiecutter-data-science/#directory-structure) proposée par le template
- créer les dossiers qui vous semblent pertinents pour contenir les différents éléments de notre projet selon le modèle
- vous aller devoir séparer le module `functions.py` en différents modules afin de pouvoir entrer dans la structure suggérée dans le dossier `src` (le dossier destiné à contenir le code source de votre package)
- vous devriez arriver à une structure semblable à celle-ci :

```shell
ensae-reproductibilite-projet
├── data
│   └── raw
│       ├── test.csv
│       └── train.csv
├── main.py
├── notebooks
│   └── titanic.ipynb
├── README.md
└── src
    ├── data
    │   ├── import_data.py
    │   └── train_test_split.py
    ├── features
    │   └── build_features.py
    └── models
        └── train_evaluate.py
```

{{% box status="tip" title="Note" icon="fa fa-hint" %}}
Il est normal d'avoir des dossiers `__pycache__` qui traînent : ils se créent automatiquement à l'exécution d'un script en Python. On verra comment les supprimer définitivement à l'étape 8.
{{% /box %}}

## Etape 6 : fixer l'environnement d'exécution {#conda-export}

Afin de favoriser la portabilité du projet, il est d'usage de "fixer l'environnement", c'est à dire d'indiquer dans un fichier toutes les dépendances utilisées ainsi que leurs version. Il est conventionnellement localisé à la racine du projet.

Sur le VSCode du SSP Cloud, on se situe dans un environnement `conda`.
La commande pour exporter un environnement `conda` est la suivante : 

```shell
$ conda env export > environment.yml
```

Vous devriez à présent avoir un fichier `environement.yml` à la racine de votre projet, qui contient les dépendances et leurs versions.

{{% box status="tip" title="Note" icon="fa fa-hint" %}}
En réalité, on aun peu triché : on a exporté l'environnement de base du VSCode SSP Cloud, qui contient beaucoup plus de packages que ceux utilisés par notre projet. On verra dans la [Partie 2](#partie2) de l'application comment fixer proprement les dépendances de notre projet.
{{% /box %}}

## Etape 7 : stocker les données de manière externe {#stockageS3}

{{% box status="warning" title="Warning" icon="fa fa-exclamation-triangle" %}}
Cette étape n'est pas facile. Vous devrez suivre la [documentation du SSP Cloud](https://docs.sspcloud.fr/onyxia-guide/stockage-de-donnees) pour la réaliser. Une aide-mémoire est également disponible dans le cours
de [Python pour les data-scientists](https://linogaliana-teaching.netlify.app/reads3/#)
{{% /box %}}

Comme on l'a vu dans le cours, les données ne sont pas censées être versionnées sur un projet Git. L'idéal pour éviter cela tout en maintenant la reproductibilité est d'utiliser une solution de stockage externe. On va utiliser pour cela `MinIO`, la solution de stockage de type `S3` offerte par le SSP Cloud. 

- créer un dossier `ensae-reproductibilite` dans votre bucket personnel via l'[interface utilisateur](https://datalab.sspcloud.fr/mes-fichiers)
- modifier votre fonction d'import des données pour qu'elle récupère les données à partir de MinIO. Elle devra prendre en paramètres le nom du bucket et le dossier dans lequel sont contenues les données sur MinIO.
- modifier le `main` script pour appeler la fonction avec les paramètres propres à votre compte
- supprimer les fichiers `.csv` du dossier `data` de votre projet, on n'en a plus besoin vu qu'on les importe de l'extérieur
- vérifier le bon fonctionnement de votre application

<!-----
mc cp train.csv s3/lgaliana/ensae-reproductibilite/train.csv
mc cp test.csv s3/lgaliana/ensae-reproductibilite/test.csv
----->

## Etape 8 : nettoyer le dépôt Git

Des dossiers parasites `__pycache__` se sont glissés dans notre projet. Ils se créent automatiquement à l'exécution d'un script en Python, afin de rendre plus rapide les exécutions ultérieures. Ils n'ont cependant pas de raison d'être versionnés, vu que ce sont des fichiers locaux (spécifiques à un environnement d'exécution donné).

- supprimer les différents dossiers `__pycache__` du projet
- ajouter le [fichier .gitignore adapté à Python](https://github.com/github/gitignore/blob/main/Python.gitignore) à la racine du projet
- ajouter le dossier `data/` au `.gitignore` pour éviter tout ajout involontaire de données au dépôt Git

{{% box status="tip" title="Note" icon="fa fa-hint" %}}
En pratique, mieux vaut adopter l'habitude de toujours mettre un `.gitignore`, pertinent selon le langage du projet, dès le début du projet. `GitHub` offre cette option à l'initialisation d'un projet. Le site
[gitignore.io](https://www.toptal.com/developers/gitignore) propose des modèles
selon le langage que vous utilisez qui peuvent être utiles.
{{% /box %}}

## Etape 9 : ouvrir une *pull request* sur le dépôt du projet

Enfin terminé ! Enfin presque... On s'est donné beaucoup de mal à nettoyer ce dépôt et le mettre aux standards, autant valoriser ce travail. On va pour cela faire une *pull request* sur le [dépôt du projet initial](https://github.com/avouacr/ensae-reproductibilite-projet), c'est à dire proposer à l'auteur d'intégrer tous les changements que vous avez effectué en committant à chaque étape. 

Suivre la procédure décrite dans la [documentation GitHub](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork) pour créer une *pull request* à partir de votre *fork*. Pour la branche *upstream* (le dépôt cible), on va choisir `master`. Par contre, pour la branche locale (celle sur votre dépôt), on va choisir la branche `nettoyage`.

Si tout s'est bien passé, vous devriez à présent voir votre *pull request* sur le dépôt cible ([ici](https://github.com/avouacr/ensae-reproductibilite-projet/pulls)). Bravo, vous venez de faire votre première contribution à l'open source !

{{% box status="warning" title="Warning" icon="fa fa-exclamation-triangle" %}}
Faire une *pull request* via la branche `master` d’un *fork* est très mal vu. En effet, il faut souvent faire des contorsionnements pour réussir à faire coïncider deux histoires qui n’ont pas de raison de coïncider. On s'évite beaucoup de problèmes en prenant l'habitude de toujours faire ses *pull requests* à partir d'une autre branche que `master`.
{{% /box %}}

# Partie 2 : construction d'un projet portable et reproductible {#partie2}

Dans la partie précédente,
on a appliqué de manière incrémentale de nombreuses bonnes pratiques vues tout au long du cours.
Ce faisant, on s'est déjà considérablement rapprochés d'une
possible mise en production : le code est lisible,
la structure du projet est normalisée et évolutive,
et le code est proprement versionné sur un
dépôt `GitHub` <i class="fab fa-github"></i>.

A présent, nous avons une version du projet qui est largement partageable.
Du moins en théorie, car la pratique est souvent plus compliquée : il y a fort à parier que si vous essayez d'exécuter votre projet sur un autre environnement (typiquement, votre ordinateur personnel),
les choses ne se passent pas du tout comme attendu. Cela signifie qu'**en l'état, le projet n'est pas portable : il n'est pas possible, sans modifications coûteuses, de l'exécuter dans un environnement différent de celui dans lequel il a été développé**.

Dans cette seconde partie, nous allons voir comment **normaliser l'environnement d'exécution afin de produire un projet portable**. On sera alors tout proche de pouvoir mettre le projet en production.
On progressera dans l'échelle de la reproductibilité 
de la manière suivante: 
- :one: [**Gérer des variables d'environnement hors du code**](#configyaml) ;
- :two: [**Environnements virtuels**](#anaconda) ;
- :three: [**Images et conteneurs `Docker`**](#docker).


## Etape 1: créer un répertoire de variables servant d'input {#configyaml}

### Enjeu

Lors de l'[étape 7](#stockageS3), nous avons amélioré la qualité du script en 
séparant stockage et code. Cependant, peut-être avez-vous remarqué
que nous avons introduit un nom de _bucket_ personnel dans le script
(voir [le fichier `main.py`](https://github.com/linogaliana/ensae-reproductibilite-projet-1/blob/v7/main.py#L9)).
Il s'agit typiquement du genre de petit vice caché d'un script qui peut 
générer une erreur: vous n'avez pas accès au bucket en question donc
si vous essayez de faire tourner ce script en l'état, vous allez rencontrer
une erreur.

Une bonne pratique pour gérer ce type de configuration est d'utiliser un 
fichier `YAML` qui stocke de manière hiérarchisée les variables globales
[^3].

[^3]: Le format `YAML` est un format de fichier où les informations sont 
hiérarchisées. Avec le _package_ `YAML` on peut très facilement le transformer
en `dict`, ce qui est très pratique pour accéder à une information.

En l'occurrence, nous n'avons besoin que de deux éléments pour pouvoir
dé-personnaliser ce script :

- le nom du bucket
- l'emplacement dans le bucket

### Application

Dans `VSCode`, créer un fichier nommé `config.yaml` et le localiser à la racine
de votre dépôt. Voici, une proposition de hiérarchisation de l'information
que vous devez adapter à votre nom d'utilisateur :

```yaml
input:
  bucket: "lgaliana"
  path: "ensae-reproductibilite"
```

Dans `main.py`, importer ce fichier et remplacer la ligne précédemment
évoquée par les valeurs du fichier. Tester en faisant tourner `main.py`
<!-----
https://github.com/linogaliana/ensae-reproductibilite-projet-1/commit/4a9d935223b6af366d4cf2a2a208d98a25407fc6
----->

## Etape 2 :  créer un environnement conda à partir du fichier `environment.yml` {#anaconda}

L'environnement `conda` créé avec `conda env export` ([étape 6](#conda-export))
contient énormément
de dépendances, dont de nombreuses qui ne nous sont pas nécessaires (il 
en serait de même avec `pip freeze`). 
Nous n'avons en effet besoin que des _packages_ présents dans la
section `import` de nos scripts et les dépendances nécessaires
pour que ces _packages_ soient fonctionnels.


Vous allez chercher à obtenir
un `environment.yml` beaucoup plus parcimonieux
que celui généré par `conda env export`

{{< panelset class="simplification" >}}

{{% panel name="Approche générale :koala: " %}}

Le tableau récapitulatif présent dans
la [partie portabilité](/portability/#aide-mémoire)
peut être utile dans cette partie. L'idée est 
de partir _from scratch_ et figer l'environnement qui
permet d'avoir une appli fonctionnelle. 

* Créer un environnement vide avec `Python 3.10`
<!---
conda create -n monenv python=3.10.0
---->

* Activer cet environnement

* Installer en ligne de commande avec `pip` les packages nécessaires
pour faire tourner votre code

<!---
pip install pandas PyYAML s3fs scikit-learn
---->

* Faire un `pip freeze > requirements.txt` ou 
`conda env export > environment.yml` (privilégier la deuxième option)

* Retirer la section `prefix` (si elle est présente)
et changer la section `name` en `monenv`


{{% /panel %}}


{{% panel name="Approche fainéante :sloth:" %}}

Nous allons générer une version plus minimaliste grâce à
l'utilitaire [`pipreqs`](https://github.com/bndr/pipreqs)

* Installer `pipreqs` en `pip install`
* En ligne de commande, depuis la racine du projet, faire `pipreqs`
* Ouvrir le `requirements.txt` automatiquement généré. Il est beaucoup plus
minimal que celui que vous obtiendriez avec `pip freeze` ou
l'`environment.yml` obtenu à [l'étape 6](#conda-export). 
* Remplacer toute la section `dependencies` du `environment.yml`
par le contenu du `requirements.txt`
(:warning: ne pas oublier l'indentation et le tiret en début de ligne)
* :warning: Modifier le tiret à `scikit learn`. Il ne faut pas un _underscore_ mais
un tiret
* Ajouter la version de python (par exemple `python=3.10.0`)
au début de la section `dependencies`
* Retirer la section `prefix` du fichier `environment.yml` (si elle est présente)
et changer le contenu de la section `name` en `monenv`
* Créer l'environnement
([voir le tableau récapitulatif dans la partie portabilité](/portability/#aide-mémoire))

<!----
conda env create -f environment.yml
------>


{{% /panel %}}

{{% /panelset %}}


Maintenant, il reste à tester si tout fonctionne bien dans notre 
environnement plus minimaliste:

* Activer l'environnement
* Tester votre script en ligne de commande
* Faire un `commit` quand vous êtes contents


## Etape 3: conteneuriser avec Docker <i class="fab fa-docker"></i> {#docker}

### Préliminaire

- Se rendre sur l'environnement bac à sable [Play with Docker](https://labs.play-with-docker.com)
- Dans le terminal `Linux`, cloner votre dépôt `Github`  <i class="fab fa-github"></i>
- Créer via la ligne de commande un fichier `Dockerfile`. Il y a plusieurs manières
de procéder, en voici un exemple:

```shell
echo "#Dockerfile pour reproduire mon super travail" > Dockerfile
```

- Ouvrir ce fichier via l'éditeur proposé par l'environnement bac à sable. 


### Création d'un premier Dockerfile



- :one: Comme couche de départ, partir d'une image légère comme `ubuntu:20.04`
- :two: Dans une deuxième couche, faire un `apt get -y update` et
installer `wget` qui va être nécessaire pour télécharger `Miniconda`
depuis la ligne
de commande 
- :three: Dans la troisième couche, nous allons installer `Miniconda` :
    + Télécharger la dernière version de `Miniconda` avec `wget` depuis
l'url de téléchargement direct https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    + Installer `Miniconda` dans le chemin `/home/coder/local/bin/conda`
    + Effacer le fichier d'installation pour libérer de la place sur l'image
- :four: En quatrième couche, on va installer `mamba` pour accélérer l'installation
des packages dans notre environnement. 
- :five: En cinquième couche, nous allons créer l'environnement `conda`:
    + Utiliser `COPY` pour que `Docker` soit en mesure d'utiliser
le fichier `environment.yml` (sinon `Docker`
renverra une erreur)
    + Créer l'environnement vide `monenv` (présentant uniquement `Python` 3.10) avec
la commande  `conda` adéquate
    + Mettre à jour l'environnement en utilisant `environment.yml` avec `mamba`
- :six: Utiliser `ENV` pour ajouter l'environnement `monenv` au `PATH` et utiliser le _fix_ suivant:

```python
RUN echo "export PATH=$PATH" >> /home/coder/.bashrc  # Temporary fix while PATH gets overwritten by code-server
```

- :seven: Exposer sur le port `5000`
- :eight: En dernière étape, utiliser `CMD` pour reproduire le comportement de `python main.py`


{{% box status="hint" title="Hint: `mamba`" icon="fa fa-lightbulb" %}}
`mamba` est une alternative à `conda` pour installer des _packages_ dans un
environnement `Miniconda`/`Anaconda`. `mamba` n'est pas obligatoire, `conda`
peut suffire. Cependant, `mamba` est beaucoup plus rapide
que `conda` pour installer des packages à installer ; il s'agit donc
d'un utilitaire très pratique. 
{{% /box %}}

{{< panelset class="nommage" >}}

{{% panel name="Indications supplémentaires" %}}

Cliquer sur les onglets ci-dessus :point_up_2: pour bénéficier
d'indications supplémentaires, pour vous aider. Cependant, essayez
de ne pas les consulter immédiatement: n'hésitez pas à tâtonner. 


{{% /panel %}}

{{% panel name="Installation de Miniconda" %}}

```shell
# INSTALL MINICONDA -------------------------------
ARG CONDA_DIR=/home/coder/local/bin/conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p $CONDA_DIR
RUN rm -f Miniconda3-latest-Linux-x86_64.sh
```

{{% /panel %}}

{{% panel name="Installation de mamba" %}}

```shell
ENV PATH="/home/coder/local/bin/conda/bin:${PATH}"
RUN conda install mamba -n base -c conda-forge
```

{{% /panel %}}


{{% panel name="Création de l'environnement" %}}

```shell
COPY environment.yml .
RUN conda create -n monenv python=3.10
RUN mamba env update -n monenv -f environment.yml
```

{{% /panel %}}


{{< /panelset >}}

### Construire l'image

Maintenant, nous avons défini notre recette. Il nous reste à
faire notre plat et à le goûter

- Utiliser `docker build` pour créer une image avec le tag `my-python-app`
- Vérifier les images dont vous disposez. Vous devriez avoir un résultat
proche de celui-ci

<!---
docker build . -t my-python-app
docker images
---->

```shell
REPOSITORY      TAG       IMAGE ID       CREATED         SIZE
my-python-app   latest    c0dfa42d8520   6 minutes ago   2.23GB
ubuntu          20.04     825d55fb6340   6 days ago      72.8MB
```

### Tester l'image: découverte du cache

Il ne reste plus qu'à goûter la recette et voir si le plat est bon. 

Utiliser `docker run` avec l'option `it` pour pouvoir appeler l'image
depuis son tag

<!----
docker run -it my-python-app
---->

:warning: :bomb: :fire: 
`Docker` ne sait pas où trouver le fichier `main.py`. D'ailleurs,
il ne connait pas d'autres fichiers de notre application qui sont nécessaires
pour faire tourner le code: `config.yaml` et le dossier `src`

- Avant l'étape `EXPOSE` utiliser plusieurs `ADD` et/ou `COPY` pour que l'application
dispose de tous les éléments minimaux pour être en mesure de fonctionner

- Refaire tourner `docker run`
<!---
docker run -it my-python-app
--->

{{% box status="tip" title="Note" icon="fa fa-hint" %}}
Ici, le _cache_ permet d'économiser beaucoup de temps. Par besoin de 
refaire tourner toutes les étapes, `Docker` agit de manière intelligente
en faisant tourner uniquement les nouvelles étapes.
{{% /box %}}

### Corriger une faille de reproductibilité


Vous devriez rencontrer une erreur liée à la variable d'environnement
`AWS_ENDPOINT_URL`. C'est normal, elle est inconnue de cet environnement
minimaliste. D'ailleurs, `Docker` n'a aucune raison de connaître
votre espace de stockage sur le `S3` du `SSP-Cloud` si vous ne lui dites
pas. 
Donc cet environnement ne sait pas
comment accéder aux fichiers présents dans votre `minio`.

Vous allez régler ce problème avec les étapes suivantes, :


- :one: Naviguer dans l'[interface du SSP-Cloud](https://datalab.sspcloud.fr/mes-fichiers)
pour retrouver les liens d'accès direct de vos fichiers
- :two: Dans `VSCode`, les mettre dans `config.yaml` (faire de nouvelles clés)
- :three: Dans `VSCode`, modifier la fonction d'import pour s'adapter à ce changement.
- :four: Faire un `commit` et pusher les fichiers
- :five: Dans l'environnement bac à sable, faire un `pull` pour récupérer ces
modifications
- :six: Tester à nouveau le `build` (là encore le _cache_ est bien pratique !)

<!---
cf. 
https://github.com/linogaliana/ensae-reproductibilite-projet-1/commit/56946b4c5cb860d50b908d98a87fb549624314a6
----->


:tada: A ce stade, la matrice de confusion doit fonctionner. Vous avez créé
votre première application reproductible !

# Partie 3 : mise en production
