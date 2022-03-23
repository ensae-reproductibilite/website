---
title: "Versionner son code et travailler collaborativement avec Git"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---
  

# Le contrôle de version

## Pourquoi faire ?

Le développement rapide de la *data science* au cours de ces dernières années s'est accompagnée d'une complexification substantielle des projets. Par ailleurs, les projets sont de plus en plus collaboratifs, que ce soit dans le cadre d'équipes dans un contexte professionnel ou bien pour des contributions à des projets open-source. Naturellement, ces évolutions doivent nous amener à modifier nos manières de travailler pour gérer cette complexité croissante et continuer à produire de la valeur à partir des projets de *data science*.

Pourtant, tout *data scientist* s'est parfois demandé :

- quelle était la bonne version d'un programme 
- qui était l'auteur d'un bout de code en particulier
- si un changement était important ou juste un essai
- comment fusionner des programmes
- etc.

Et il n'est pas rare de perdre le fil des versions de son projet lorsque l'on garde trace de celles-ci de façon manuelle.

**Exemple de contrôle de version fait "à la main"**
![](/fichiers_multiples.png)

Pourtant, il existe un outil informatique puissant afin de répondre à tous ces besoins : la gestion de version (*version control system* (VCS) en anglais). Ses avantages sont incontestables et permettent de facilement :

- enregistrer l'historique des modifications d'un ensemble de fichiers 
- revenir à des versions précédentes d'un ou plusieurs fichiers
- rechercher les modifications qui ont pu créer des erreurs
- travailler simultanément sur un même fichier sans risque de perte
- partager ses modifications et récupérer celles des autres
- proposer des modifications, les discuter, sans pour autant modifier la dernière version existante
- identifier les auteurs et la date des modifications

En outre, ces outils fonctionnent avec tous les langages informatiques car ils reposent sur la comparaison des lignes et des caractères des programmes, indépendamment du langage. En bref, c'est la bonne manière pour partager des codes et travailler à plusieurs sur un projet de *data science*. En réalité, il ne serait pas exagéré de dire que **l'utilisation du contrôle de version est la bonne pratique la plus fondamentale de tout projet faisant intervenir du code**, et qu'elle conditionne largement toutes les autres.

## Pourquoi Git ?

Plusieurs logiciels de contrôle de version existent sur le marché. En principe, le logiciel Git, développé initialement pour fournir une solution décentralisée et *open-source* dans le cadre du développement du noyau Linux, est devenu largement hégémonique. Aussi, **toutes les application de ce cours s'effectueront à l'aide du logiciel Git**.

## Pourquoi GitHub ?

Travailler de manière collaborative avec Git implique de synchroniser son répertoire local avec une copie distante, située sur un serveur hébergeant des projets Git. Ce serveur peut être un serveur interne à une organisation, ou bien être fourni par un hébergeur externe. Les deux alternatives les plus populaires en la matière sont GitHub et GitLab. Dans ce cours, **nous utiliserons GitHub, qui est devenu au fil des années la référence pour l'hébergement des projets open-source**. En pratique, les deux services sont relativement semblables, et tous les concepts présentés se retrouvent sous une forme similaire sur les deux plateformes.



# Des bases de Git

Ce cours part du principe que les lecteurs sont déjà familiers avec l'utilisation de Git, au travers de projets individuels ou collectifs. Aussi, nous rappelons dans cette section les notions essentielles de Git, mais nous ne présenterons pas leur implémentation pratique. Le lecteur souhaitant un rappel plus complet peut par exemple se référer à la [formation au travail collaboratif avec Git et RStudio](https://collaboratif-git-formation-insee.netlify.app/index.html) donnée à l'Insee, dont sont issues de nombreuses ressources utilisées dans ce chapitre.

## Principes et commandes usuelles

Le graphique suivant illustre les principes fondamentaux de Git.

**Git tout-en-un** ([Source](http://fabacademy.org/2021/labs/bhubaneswar/students/deepak-chaudhry/ia_PPFP.html))
![](/gitallinone.png)

Lorsqu'on utilise Git, il est important de **bien distinguer ce qui se passe en local** (sur son poste, sur le serveur sur lequel on travaille...) **de ce qui se passe en *remote***, i.e. en intéragissant avec un serveur distant. Comme le montre le graphique, l'essentiel du contrôle de version se passe en réalité en local. 

En théorie, sur un projet individuel, il est même possible de réaliser l'ensemble du contrôle de version en mode hors-ligne. Pour cela, il suffit d'indiquer à Git le projet (dossier) que l'on souhaite versionner en utilisant la commande `git init`. Cette commande a pour effet de créer un dossier `.git` à la racine du projet, dans lequel Git va stocker tout l'historique du projet (commits, branches, etc.) et permettre de naviguer entre les versions. A cause du `.` qui préfixe son nom, ce dossier est généralement caché par défaut, ce qui n'est pas problématique dans la mesure où il n'y a jamais besoin de le parcourir ou de le modifier à la main en pratique. Retenez simplement que **c'est la présence de ce dossier `.git` qui fait qu'un dossier est considéré comme un projet Git**, et donc que vous pouvez utilisez les commandes usuelles de Git dans ce dossier à l'aide d'un terminal :
- `git status` : affiche les modifications du projet par rapport à la version précédente ;
- `git add chemin_du_fichier` : ajoute un fichier nouveau ou modifié à la zone de *staging* de Git en vue d'un commit ;
- `git add -A` : ajoute tous les fichiers nouveaux ou modifiés à la zone de *staging* ;
- `git commit -m "message de commit"` : crée un commit, i.e. une photographie des modifications (ajouts, modifications, suppressions) apportées au projet depuis la dernière version, et lui assigne un message décrivant ces changements. Les commits sont l'unité de base de l'historique du projet construit par Git.

En pratique, travailler uniquement en local n'est pas très intéressant. Pour pouvoir travailler de manière collaborative, on va vouloir **synchroniser les différentes copies locales du projet à un répertoire centralisé**, qui maintient de fait la "source de vérité" (*single source of truth*). Même sur un projet individuel, il fait sens de synchroniser son répertoire local à une copie distante pour assurer l'intégrité du code de son projet en cas de problème matériel.

En général, on va donc initialiser le projet dans l'autre sens :
- créer un nouveau projet sur GitHub
- générer un [jeton d'accès](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) (*personal access token*)
- cloner le projet en local via la méthode HTTPS : `git clone https://github.com/<username>/<project_name>.git`

Le projet cloné est un projet Git — il contient le dossier `.git` — synchronisé par défaut avec le répertoire distant. On peut le vérifier avec la commande `remote` de Git :

```bash
$ git remote -v
origin  https://github.com/linogaliana/ensae-reproductibilite-website.git (fetch)
origin  https://github.com/linogaliana/ensae-reproductibilite-website.git (push)
```

Le projet local est bien lié au répertoire distant sur GitHub, auquel Git donne par défaut le nom `origin`. Ce lien permet d'utiliser les commandes de synchronisation usuelles : 
- `git pull` : récupérer les changements (*fetch*) sur le *remote* et les appliquer au projet local
- `git push` : envoyer les changements locaux sur le *remote*

## En pratique

Git est un logiciel, qui peut être téléchargé sur le [site officiel](https://git-scm.com/downloads) pour différents systèmes d'exploitation. Il existe cependant différentes manières d'utiliser Git :
- le **client en ligne de commande** : c'est l'implémentation standard, et donc la plus complète. C'est celle qu'on utilisera dans ce cours. Le client Git est installé par défaut sur les différents services du SSP Cloud (VSCode, RStudio, Jupyter, etc.) et peut donc être utilisé via n'importe quel terminal. La [documentation](https://docs.sspcloud.fr/onyxia-guide/controle-de-version) du SSP Cloud détaille la procédure ;
- des **interfaces graphiques** : elles facilitent la prise en main de Git via des guides visuels, mais ne permettent pas de réaliser toutes les opérations permises par Git
  - l'interface native de `RStudio` pour les utilisateurs de `R` : très complète et stable. La [formation au travail collaboratif avec Git et RStudio](https://collaboratif-git-formation-insee.netlify.app/index.html) présente son utilisation de manière détaillée ;
  - le plugin `Jupyter-git` pour les utilisateurs de `Python` : elle implémente les principales *features* de Git, mais s'avère assez instable à l'usage.



# Git avancé

Dans la section précédente, on a présenté une manière de travailler assez basique : dès lors que l'on a réalisé un ensemble de modifications cohérent sur le projet, on produit un commit, ce qui permet de construire progressivement l'historique du projet. Si cette méthode peut tout à fait convenir à des petits projets, elle montre rapidement ses limites dès lors que les projets gagnent en maturité ou deviennent collaboratifs :
- on va généralement vouloir garder une version "propre" du projet (ex : une application fonctionnelle), et expérimenter par ailleurs pour développer de nouvelles fonctionnalités ;
- on peut être amené à travailler à plusieurs sur les mêmes fichiers et ce de façon simultanée, ce qui peut générer des conflits complexes à gérer

On le voit bien : **dès lors qu'un projet gagne de l'ampleur, il est impératif de s'interroger en amont sur l'organisation du travail et de trouver des manières de collaborer efficacement**. On va pour cela s'inspirer de modèles d'organisation (***workflows***) qui ont fait leurs preuves, ce qui va nous amener à nous intéresser à une des fonctionnalités majeures de Git : les **branches**. On verra également que les services tels que GitHub ou GitLab fournissent des fonctionnalités additionnelles (***issues***, ***pull requests*** et ***forks***) qui permettent de grandement faciliter le travail collaboratif avec Git.

## Branches

### Concept

La possibilité de créer des branches est l'une des fonctionnalités majeures de Git. La création d'une branche au sein d'un projet permet de diverger de la ligne principale de développement (généralement appelée `master`, terme tendant à disparaître au profit de celui de `main`) sans impacter cette ligne. Cela permet de séparer le nouveau développement et de **faire cohabiter plusieurs versions, pouvant évoluer séparément et pouvant être facilement rassemblées si nécessaire**.

Pour comprendre comment fonctionnent les branches, il nous faut revenir un peu plus en détail sur la manière dont Git stocke l'historique du projet. Comme nous l'avons vu, l'unité temporelle de Git est le commit, qui correspond à une photographie à un instant donné de l'état du projet (*snapshot*). Chaque commit est uniquement identifié par un *hash*, une longue suite de caractères. La commande `git log`, qui liste les différents commits d'un projet, permet d'afficher ce *hash* ainsi que diverses métadonnées (auteur, date, message) associées au commit.

```bash
$ git log
commit e58b004d3b68bdf28093fe6ad6036b5d13216e55 (HEAD -> master, origin/master, origin/HEAD)
Author: Lino Galiana <xxx@yahoo.fr>
Date:   Tue Mar 22 14:34:04 2022 +0100

    ajoute code équivalent python

...
```

Une branche est simplement un pointeur vers un commit. Dans l'exemple précédent, on a imprimé les informations du dernier commit en date. La branche principale (`master`) pointe vers ce commit. Si l'on faisait un nouveau commit, le pointeur se décalerait et la branche `master` pointerait à présent sur le nouveau commit. 

### Branches locales

Dans ce contexte, créer une nouvelle branche (en local) revient simplement à créer un nouveau pointeur vers un commit donné. Supposons que l'on crée une branche `testing` à partir du dernier commit.

```bash
$ git branch testing  # Crée une nouvelle branche
$ git branch  # Liste les branches existantes
* master  # La branche sur laquelle on se situe
  testing  # La nouvelle branche créée
```

La figure suivante illustre l'effet de cette création sur l'historique Git.

![](/newbranch.png)

Désormais, deux branches (`master` et `testing`) pointent vers le même commit. Si l'on effectue à présent des commits sur la branche `testing`, on va diverger de la branche principale, ce qui permet de développer une nouvelle fonctionnalité sans risquer d'impacter `master`. 

Pour savoir sur quelle branche on se situe à instant donné — et donc sur quelle branche on va commiter — Git utilise un pointeur spécial, appelé `HEAD`, qui pointe vers la branche courante. On comprend à présent mieux la signification de `HEAD -> master` dans l'output de la commande `git log` vu précédemment. Cet élément spécifie la situation *locale* actuelle et signifie : on se situe actuellement sur la branche `master`, qui pointe sur le commit `e58b004`. Pour changer de branche, i.e. déplacer le `HEAD`, on utilise la commande `git checkout`. Par exemple, pour passer de la branche `master` sur laquelle on est par défaut à la branche `testing` :

```bash
$ git checkout testing  # Changement de branche
Switched to branch 'testing'
```

On se situe désormais sur la branche `testing`, sur laquelle on peut laisser libre cours à sa créativité sans risquer d'impacer la branche principale du projet. Mais que se passe-t-il si, pendant que l'on développe sur `testing`, un autre membre du projet commit sur `master` ? On dit que les historiques ont divergé. La figure suivante illustre à quoi ressemble à présent l'historique du projet (et suppose que l'on est repassé sur `master`).

![](/divergence.png)

Cette divergence n'est pas problématique en soi : il est normal que les différentes parties et expérimentations d'un projet avancent à différents rythmes. La difficulté est de savoir comment réconcillier les différents changements si l'on décide que la branche `testing` doit être intégrée dans `master`. Deux situations peuvent survenir :
- les modifications opérées en parallèle sur les deux branches ne concernent pas les mêmes fichiers ou les mêmes parties des fichiers. Dans ce cas, Git est capable de fusionner (*merge*) les changements automatiquement et tout se passe sans encombre ;
- dans le cas contraire, survient un *merge conflict* : les branches ont divergé de telle sorte qu'il n'est pas possible pour Git de fusionner les changements automatiquement. Il faut alors résoudre les conflits manuellement.

La résolution des conflits est une étape souvent douloureuse lors de l'apprentissage de Git. Aussi, nous conseillons dans la mesure du possible de ne pas fusionner des branches manuellement en local avec Git — c'est d'ailleurs pour cette raison que nous n'avons pas détaillé les commandes pour le faire. Dans les sections suivantes, nous verrons comment une bonne organisation préalable du travail en équipe, combinée aux outils collaboratifs fournis par GitHub, permet de rendre le processus de fusion des branches largement indolore.

### Branches *remote*

Rappellons que toutes les opérations que nous avons effectuées sur les branches dans cette section se sont passés en local, le répertoire distant est resté totalement inchangé.

## Workflow collaboratif

Comme on l'a vu précédemment, si le modèle des branches de Git semble idéal pour gérer le travail collaboratif et asynchrone, il peut également s'avérer rapidement complexe à manipuler en l'absence d'une bonne organisation du travail en équipe. De nombreux modèles ("*workflows*") existent en la matière, avec des complexités plus ou moins grandes selon la nature du projet. Nous conseillons d'adopter dans la plupart des cas un modèle très simple : le [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow).

Le *GitHub Flow* est une méthode d'organisation minimaliste du travail collaboratif, qui est progressivement devenue la norme dans les projets open-source. Elle est résumée par la figure suivante, dont nous détaillons par la suite les différentes étapes.

![](/ghflow.png)

### Définition des rôles des contributeurs

Dans tout projet collaboratif, une première étape essentielle est de bien délimiter les rôles des différents contributeurs. Les différents participants au projet ont en effet généralement des rôles différents dans l'organisation, des niveaux différents de pratique de Git, etc. Il est important de refléter ces différents rôles dans l'organisation du travail collaboratif.

Sur les différents hébergeurs de projets Git, cela prend la forme de rôles que l'on attribue aux différents membres du porjet. Les *mainteneurs* sont les seuls à pouvoir écrire directement sur `master`. Les *contributeurs* sont quant à eux tenus de développer sur des branches. Cela permet de protéger la branche principale, qui doit rester une version propre et jamais compromise du projet.

Notons que la possibilité de donner des rôles sur les projets GitHub n'est possible que dans le cadre d'organisations (payantes), donc dans un contexte professionnel ou de projets open-source d'une certaine ampleur. Pour des petits projets, il est nécessaire de s'astreindre à une certaine rigueur individuelle pour respecter cette organisation.

### Développement sur des branches de court-terme

Les contributeurs développent uniquement sur des branches. Il est d'usage de créer une branche par fonctionnalité, en lui donnant un nom reflétant la fonctionnalité en cours de développement (ex : `ajout-tests-unitaires`). Les différents contributeurs à la fonctionnalité en cours de développement font des commits sur la branche, en prenant bien soin de `pull` régulièrement les éventuels changements pour ne pas risquer de conflits de version. Pour la même raison, il est préférable de faire des branches dites de court-terme, c'est à dire propres à une petite fonctionnalité, quite à diviser une fonctionnalité en séries d'implémentations. Cela permet de limiter les éventuels conflits à gérer lors de la fusion finale de la branche avec `master`.

### Pull Request

Une fois la série de modifications terminée, vient le temps de rassembler les différents travaux, par l’intermédiaire de la fusion entre la branche et `master`. Il faut alors “demander” de fusionner (*pull request*) sur GitHub. Cela ouvre une page liée à la *pull request*, qui rappelle les différents changements apportés et leurs auteurs, et permet d'entamer une discussion à propos de ces changements.

### Processus de *review*

Les différents membres du projet peuvent donc analyser et commenter les changements, poser des questions, suggérer des modifications, apporter d'autres contributions, etc. Il est par exemple possible de mentionner un membre de l’équipe par l’intermédiaire de `@personne`. Il est également possible de procéder à une *code review*, par exemple par un développeur plus expérimenté.

### Résolution des éventuels conflits

En adoptant cette manière de travailler, `master` ne sera modifiée que via des *pull requests*. Il ne devrait donc jamais y avoir le moindre conflit à régler sur `master `, les seuls conflits possibles se passent sur les branches. Par exemple, dans le cas où une autre *pull request* aurait été fusionnée sur `master` depuis l'ouverture de la *pull request* en question.

Dans le cas d'un conflit à gérer, le conflit doit être résolu dans la branche et pas dans `master`. Voici la marche à suivre :

- appliquez le conseil de survie : faites une copie de sauvegarde de votre clone
- dans votre clone, placez vous sur la branche en question : `git checkout nom-de-la-branche`
- fusionnez `master` dans la branche : `git merge master`
- résolvez les éventuels conflits dans les fichiers concernés
- finalisez le commit de merge et poussez-le sur la branche *remote*, ce qui le fera apparaître dans la *pull request*

### Fusion de la branche

Si tout est en ordre, la branche peut être fusionnée. Seuls les *mainteneurs*, qui ont les droits sur `master`, peuvent fusionner la *pull request*. 

## Issues

## Contributer à des projets open-source

- via Fork + PR
- suivre les règles de contribution du projet





# Bonnes pratiques de Git

- messages de commit
- commits réguliers
- quoi versionner
- .gitignore
- revenir en arrière
- fixer les conflits
- gestion des droits d'accès
- contributions open source
- workflows

# Application

- individuel
  - exercice guidé add/commit/push/pull/checkout
  - mise sur GitHub d'un projet personnel
- collaboratif
  - cadavre exquis
  - PR à partir d'un fork
