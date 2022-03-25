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

Tout cela est bien intéressant, mais en quoi est-ce pertinent pour le *data scientist*, dont le rôle n'est pas de développer des applications mais de donner du sens aux données ? Du fait du développement rapide de la *data science* et conséquemment de la croissance de la taille moyenne des projets, l'activité du *data scientist* tend à se rapprocher par certains aspects de celle du développeur :
- les projets sur lesquels travaille le *data scientist* sont intenses en code ;
- il doit travailler de manière collaborative au sein de projets de grande envergure ;
- il est de plus en plus amené à travailler à partir de données massives, ce qui nécessite de travailler sur des infrastructures *big data* informatiquement complexes ;
- il est amené à interagir avec des profils informatiques pour déployer ses modèles et les rendre accessible à des utilisateurs.

Aussi, il fait sens pour le *data scientist* moderne de s'intéresser aux bonnes pratiques en vigueur dans la communauté des développeurs. Bien entendu, celles-ci doivent être adaptées aux spécificités des projets basés sur des données. Faisons à présent un tour d'horizon des bonnes pratiques et des outils que nous verrons tout au long ce cours.

## Contenu du cours

### Voir le code comme un outil de communication
        
La première bonne pratique à adopter est de considérer le code comme un outil de communication, et non simplement de manière fonctionnelle. Un code ne sert pas seulement à réaliser une tâche donnée, il a vocation à être diffusé, réutilisé, maintenu, que ce soit dans le contexte d'une équipe dans une organisation ou bien en *open-source*. Pour favoriser cette communication du code, des conventions ont été developpées en matière de qualité du code et de structuration des projets, qu'il est utile d'appliquer dans ses projets. Nous présentons ces conventions dans le chapitre [Structuration et Qualité du Code]({{< ref "/content/code-architecture.md" >}}).

Il est pour les mêmes raisons indispensable d'appliquer les principes du contrôle de version, qui permettent une documentation en continu des projets, ce qui accroît fortement leur réutilisabilité et leur maintenabilité dans le temps. Nous présentons pour cela l'utilisation du logiciel Git dans le chapitre [Versionner son code et travailler collaborativement avec Git]({{< ref "/content/git.md" >}}).

### Travailler de manière collaborative

Le *data scientist*, quel que soit son contexte de travail, est amené à travailler dans le cadre de projets en équipe. Cela implique de définir une organisation du travail ainsi que d'utiliser des outils permettant de collaborer sur un projet de manière efficace et sécurisée. Nous présentons une manière moderne de travailler collaborativement avec Git et GitHub dans le chapitre [Versionner son code et travailler collaborativement avec Git]({{< ref "/content/git.md" >}}).

### Maximiser la reproductibilité

Le troisième pillier des bonnes pratiques discutées dans ce cours est la **reproductibilité**. Un projet est dit reproductible lorsque, **avec le même code et les mêmes données, il est possible de reproduire les résultats obtenus**. Notons bien que le problème de la reproductibilité est différent de celui de la **réplicabilité**. La réplicabilité est un concept *scientifique*, qui signifie qu'un même procédé expérimental donne des résultats analogues sur des jeux de données différents. La reproductibilité est un concept *technique* : elle ne signifie pas que le protocole expérimental est scientifiquement correct, mais qu'il a été spécifié et diffusé d'une manière qui permet à tous de reproduire les résultats obtenus.

**La notion de reproductibilité est le fil rouge de ce cours** : toutes les notions vues dans les différents chapitres y contribuent. Le fait de produire du code et des projets qui respectent les conventions communautaires, comme le fait d'utiliser le contrôle de version, contribuent à rendre le code plus lisible et documenté, et donc reproductible. 

Il faut néanmoins aller plus loin pour atteindre une véritable reproductibilité, et réfléchir à la notion d'**environnement d'exécution**. Un code n'est pas un objet autonome, il est toujours exécuté sur un environnement (ordinateur personnel, serveur, etc.), et ces environnements peuvent être très différents (système d'exploitation, librairies installées, contraintes de sécurité, etc.). C'est pourquoi il faut réfléchir à la **portabilité de son code, i.e. sa capacité à s'exécuter de manière attendue sur différents environnements**. Le chapitre [Portabilité]({{< ref "/content/portability.md" >}}) présente une série d'outils qui permettent d'accroître la portabilité d'un projet.

### Faciliter la mise en production

Pour qu'un projet de *data science* crée *in fine* de la valeur, il faut qu'il soit déployé sous une forme valorisable de sorte à toucher son public. Cela implique deux choses :
- trouver le format de diffusion adapté, i.e. qui valorise au mieux les résultas obtenus auprès des utilisateurs potentiels ;
- faire transitionner le projet de l'environnement dans lequel il a été développé vers une infrastructure de production, i.e. permettant un déploiement robuste de l'*output* du projet.

Dans le chapitre [Déployer et valoriser son projet de data science]({{< ref "/content/deployment.md" >}}), nous proposons des pistes permettant de répondre à ces deux besoins. Nous présentons un certain nombre de formats standards (API, application, rapport automatisé, site internet) qui permettent à un projet de *data science* d'être valorisé, ainsi que les outils modernes qui permettent de les produire. Nous détaillons ensuite les concepts essentiels du déploiement sur une infrastructure de production, et illustrons ces derniers par des exemples de déploiements dans un environnement *cloud* moderne.

C'est en quelque sorte la récompense de l'application des bonnes pratiques : dès lors que l'on s'est donné la peine de produire un code et un projet appliquant des standards de qualité, que l'on a bien versionné son code, et que l'on a pris des mesures pour le rendre portable, le déploiement du projet dans un environnement de production s'en trouve largement facilité.

### Outils supplémentaires

Plusieurs outils présentés tout au long de ce cours, tels que les logiciels Git et Docker, impliquent l'utilisation du terminal ainsi que des connaissances de base du fonctionnement d'un système Linux. Dans le chapitre [Démystifier le terminal Linux pour gagner en autonomie]({{< ref "/content/linux-101.md" >}}), nous présentons les connaissances essentielles des systèmes Linux qu'un *data scientist* doit posséder pour pouvoir être autonome dans ses déploiements et dans l'application des bonnes pratiques de développement.

La reproductibilité étant une quête sans fin, nous concluons ce cours par un chapitre nommé [Des ressources pour aller plus loin dans l'industrialisation de son projet]({{< ref "/content/advanced-notions.md" >}}). Comme son nom l'indique, il vise à pointer vers un certain nombre de ressources qui permettent d'améliorer encore et toujours ses pratiques et de s'intéresser à des sujets qui dépassent le cadre de ce cours, comme la sécurité ou encore les spécificités liées au déploiement et à la maintenance de modèles de *machine learning*.

## Un continuum de bonnes pratiques

La notion de bonnes pratiques ne doit pas être vue de manière binaire : il n'y a pas d'un côté les projets qui les appliquent et de l'autre ceux qui ne les appliquent pas. Les bonnes pratiques ont un coût, qu'il ne faut pas négliger — même si leur application évite aussi des coûts futurs, notamment en terme de maintenance. Il faut donc plutôt **voir les bonnes pratiques comme un spectre, sur lequel on vient positionner son projet en fonction de différents critères**.

### Comment fixer le bon seuil ?

La détermination du seuil pertinent doit résulter d'un arbitrage entre différents critères liés au projet :
- **ambitions** : le projet est-il amené à évoluer, prendre de l'ampleur ? Est-il destiné à devenir collaboratif, que ce soit dans le cadre d'une équipe en organisation ou bien en *open-source* ? Les *outputs* du projet ont-ils vocation à être diffusés au grand public ?
- **ressources** : quels sont les moyens humain du projet ? Pour un projet *open-source*, existe-t-il une communauté potentiel de contributeurs ?
- **contraintes** : le projet a-t-il une échéance proche ? Des exigences de qualité ont-elles été fixées ? Est-il destiné à la mise en production ? Existe-t-il des enjeux de sécurité forts ?

Il n'est donc pas question pour nous de suggérer que tout projet de *data science* doit respecter toutes les bonnes pratiques présentées dans ce cours. 

### Un socle minimal pour les projets de data science ?

Cela étant dit, nous sommes convaincus qu'il est important pour tout *data scientist* de réfléchir à ces questions pour améliorer ces pratiques au fil du temps. En particulier, nous pensons qu'il est possible de définir un socle, i.e. un **ensemble minimal de bonnes pratiques** qui apportent plus d'avantages qu'elles ne coûtent à implémenter. Notre suggestion pour un tel socle est la suivante :
- contrôler la qualité de son code en utilisant des outils dédiés (cf. chapitre [Structuration et Qualité du Code]({{< ref "/content/code-architecture.md" >}})) ;
- adopter une structure de projet standardisée en utilisant des *templates* prêts à l'emploi (cf. chapitre [Structuration et Qualité du Code]({{< ref "/content/code-architecture.md" >}})) ;
- utiliser Git pour versionner le code de ses projets, qu'ils soient individuels ou collectifs (cf. chapitre [Versionner son code et travailler collaborativement avec Git]({{< ref "/content/git.md" >}})) ;
- contrôler les dépendances de son projet en développant dans des environnements virtuels (cf. chapitre [Portabilité]({{< ref "/content/portability.md" >}})).


# Modalités pratiques

## Approche pédagogique

Le parti pris de ce cours est que seule la pratique, et en particulier la confrontation à des problèmes issus de projets réels, permet d'acquérir efficacement des concepts informatiques. Aussi, une large part du cours consistera en l'**application des notions étudiées à des cas concrets**. Chaque chapitre se concluera pas des applications touchant à des sujets réalistes de *data science*.

Pour l'évaluation générale du cours, l'idée sera de partir d'un projet personnel, idéalement terminé, et de lui appliquer un maximum de bonnes pratiques présentées dans ce cours.

## Langages

Les principes présentés dans ce cours sont pour la plupart **agnostiques du langage de programmation utilisé**. Ce choix n'est pas qu'éditorial, c'est selon nous un aspect fondamental du sujet des bonnes pratiques. Trop souvent, des différences de langage entre les phases de développement (ex : R, Python) et de mise en production (ex : Java) érigent des murs artificiels qui réduisent fortement la capacité à valoriser des projets de *data science*. A l'inverse, plus les différentes équipes qui forment le cycle de vie d'un projet s'accordent pour appliquer le même ensemble de bonnes pratiques, plus ces équipes développent un langage commun, et plus les déploiements en sont facilités. Un exemple parlant est l'utilisation de la conteneurisation : si le *data scientist* met à disposition une image `Docker` comme *output* de sa phase de développement et que le *data engineer* s'occupe de déployer cette image sur une infrastructure dédiée, le contenu même de l'application en termes de langage importe finalement assez peu. Cet exemple, certes simpliste, illustre malgré tout l'enjeu des bonnes pratiques en matière de communication au sein d'un projet.

Les exemples présentés dans ce cours seront pour l'essentiel en `Python` et en `R`. La principale raison et que ces langages sont enseignés dans la majorité des cursus de *data science*. Encore une fois, il est tout à fait possible d'appliquer les mêmes principes avec d'autres langages, et nous encourageons les étudiants à s'essayer à cet exercice formateur.

## Environnement d'exécution

A l'instar du langage, les principes appliqués dans ce cours sont agnostiques à l'infrastructure utilisée pour faire tourner les exemples proposés. Il est donc à la fois possible et souhaitable d'appliquer les bonnes pratiques aussi bien à un projet individuel développé sur un ordinateur personnel qu'à un projet collaboratif visant à être déployé sur une infrastructure de production dédiée.

Cependant, nous choisissons comme environnement de référence tout au long de ce cours le [SSP Cloud](https://datalab.sspcloud.fr/home), une plateforme de services pour la *data science* développée à l'Insee et accessible aux élèves des écoles statistiques. Les raisons de ce choix sont multiples :
- **l'environnement de développement est normalisé** : les serveurs du SSP Cloud ont une configuration homogène — notamment, ils se basent sur une même distribution Linux (Debian) — ce qui garantit la reproductibilité des exemples présentés tout au long du cours ;
- via un cluster Kubernetes sous-jacent, le SSP Cloud met à disposition une infrastructure robuste permettant le déploiement automatisé d'applications potentiellement intensives en données, ce qui permet de **simuler un véritable environnement de production** ;
- le SSP Cloud est construit selon les standards les plus récents des infrastructures *data science*, et permet donc d'**acquérir les bonnes pratiques de manière organique** :
  - les services sont lancés via des conteneurs, configurés par des images *Docker*. Cela permet de garantir une forte **reproductibilité** des déploiements, au prix d'une phase de développement un peu plus coûteuse ;
  - le SSP Cloud est basé sur une **approche dite *cloud native*** : il est construit sur un ensemble modulaire de briques logicielles, qui permettent d'appliquer une séparation nette du code, des données, de la configuration et de l'environnement d'exécution, principe majeur des bonnes pratiques qui reviendra tout au long de ce cours.
