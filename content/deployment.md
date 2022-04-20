---
  title: "Déployer et valoriser son projet de data science"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---
  

# Qu'est-ce que la mise en production ?

Dans les chapitres précédents, nous avons exploré la manière
dont une structure de projet et de code adéquate facilite
la réutilisation d'un projet. Cependant, le code est rarement,
en soi, le produit final mais un moyen. Le code peut
servir à mettre en oeuvre une application, à effectuer
des traitements sur une base de données pour un papier ou 
un rapport, etc. La fréquence de ré-utilisation du code peut
elle-même être variable: certains projets vont être utilisés
quotidiennement alors que d'autres ne le seront qu'à des
échéances diverses. 

Comme tout produit, un projet a un cycle de vie. Pour faire
simple, on peut séparer celui-ci en trois phases:

- la phase de développement correspond à l'écriture du code et
à des exploitations exploratoires ;
- la phase de mise en production correspond à l'adaptation du prototype
à des contraintes nécessaires pour qu'un projet produise un _output_ à
la demande ;
- la phase de maintenance correspond à la situation où on ne met plus
en oeuvre de nouvelles fonctionalités mais où on s'assure qu'un projet
informatique continue de produire les _output_ désirés malgré l'évolution
du contexte. 

En pratique, la distinction entre ces moments d'un projet peut être 
floue. Par exemple, grâce à `Git`, on peut ainsi mettre en oeuvre de 
nouvelles fonctionalités (protypage correspond à la
phase de développement) parallèles à celles déjà existantes (phase 
de maintenance). Néanmoins, ces différences conceptuelles sont intéressantes
pour appréhender les contraintes différentes de ces phases
d'un projet. 


## Importance des bonnes pratiques

Les bonnes pratiques mises en oeuvre jusqu'à présent avaient pour
objectif de faciliter la compréhension et la réutilisation d'un 
projet. Elles sont donc particulièrement appropriées pour réduire
le coût en temps de la mise en production et de la maintenance
d'un projet. Ces coûts pourraient amener un projet, même utile,
à être abandonné. 


## Environnements de production

De même, l'emphase du chapitre précédent sur la portabilité
vise à faciliter la mise en production. En effet, en créant
un environnement normalisé qui créé des conditions simples
pour reproduire certains _output_, on évite un hiatus 
entre le protypage et la mise en production. 


# Différents types de livrable

L'écosystème de la _data-science_ est florissant et permet
une grande variété d'_output_ qui vont toucher des publics
différents. Selon le type de projet, on peut retrouver
plusieurs livrables: 

- base de données ;
- API pour mettre à disposition un modèle  ;
- application  ;
- rapport automatisé ;
- site internet  ;
- ...


L'objectif du présent chapitre est de proposer des
méthodes pour anticiper la mise en production d'un
projet en intégrant, dès la phase de prototypage,
la production de livrables valorisant un projet
de _data-science_. 

Ces méthodes nous amèneront à explorer plusieurs écosystèmes, pour lesquels 
on retrouve quelques _buzz-words_ dont voici les définitions :

| Terme | Définition|
|------|--------|
| [`devops`](https://fr.wikipedia.org/wiki/Devops) | mouvement en ingénierie informatique et une pratique technique visant à l'unification du développement logiciel (dev) et de l'administration des infrastructures informatiques (ops) |
| [`MLOps`](https://fr.wikipedia.org/wiki/MLOps) | ensemble de pratiques qui vise à déployer et maintenir des modèles de machine learning en production de manière fiable et efficace |
| `CI/CD` | combinaison des pratiques d'intégration continue et de livraison continue ou de déploiement continu |



# Approches

## Pipelines de données

Une chaine de production implique plusieurs étapes qui peuvent éventuellement 
nécessiter plusieurs langages. Ces étapes peuvent être vues comme des 
transformations à la chaine d'un ou plusieurs inputs afin de produire
un ou plusieurs output.

La représentation de ces étapes peut être faite à l'aide des diagrammes
acycliques dirigés (DAG):

![](https://miro.medium.com/max/1400/1*grWvT-3jUcrnbTrsVtRHAg.png)

Un _workflow_ complet sera ainsi reproductible si on peut, en ayant accès
aux _inputs_ et à l'ensemble des règles de transformation reproduire
exactement les outputs. 
Si les inputs ou le code change, on peut être en mesure de mettre à jour
les outputs, si possible sans faire retourner les parties du projet non
concernés. 

Une première manière de développer est l'approche manuelle, qui est une tâche
digne de Sisyphe:

1. Ecriture du code
2. Exécution du code jusqu'à sa fin
3. Découverte d'une erreur ou mise à jour du code ou des données
4. Relance le code dans son ensemble

Pour éviter ce cycle interminable, on est tenté d'écrire des bases
intermédiaires et de ne faire tourner qu'une partie du code. 
Cette approche, si elle a l'avantage de faire gagner du temps, est 
néanmoins dangereuse car on peut facilement oublier de mettre à jour
une base intermédiaire qui a changé ou au contraire refaire tourner
une partie du code qui n'a pas été mise à jour. 

Il existe des méthodes plus fiables pour éviter ces gestes manuels. 
Celles-ci sont inspirées de [GNU Make](https://www.gnu.org/software/make/)
et consistent à créer le chemin de dépendance de la chaine de production 
(lister l'environnement, les inputs et les outputs à produire), à déterminer
les chemins affectés par un changement de code ou de données pour
ne faire tourner à nouveau que les étapes nécessaires. 

Les implémentations en `Python` et `R` sont nombreuses. Parmi celles-ci, on
peut mettre en valeur

- [`snakemake`](https://snakemake.readthedocs.io/en/stable/) pour `Python`
- [`targets`](https://books.ropensci.org/targets/) pour `R`


## Orchestration

Certains outils vont plus loin:

- argo
- mlflow
- airflow

# CI/CD

## Définition

> L’intégration continue est un ensemble de pratiques utilisées en génie logiciel consistant à vérifier à chaque modification de code source que le résultat des modifications ne produit pas de régression dans l’application développée. […] Elle permet d’automatiser l’exécution des suites de tests et de voir l’évolution du développement du logiciel.

> La livraison continue est une approche d’ingénierie logicielle dans laquelle les équipes produisent des logiciels dans des cycles courts, ce qui permet de le mettre à disposition à n’importe quel moment. Le but est de construire, tester et diffuser un logiciel plus rapidement.

![](cicd_exemple.png)

## Avantages

L'approche CI/CD garantit une automatisation et une surveillance continues
tout au long du cycle de vie d'un projet. 

Cela présente de nombreux avantages:

- on peut anticiper les contraintes de la mise en production grâce à des environnements
normalisés partant d'image docker standardisées
- on peut tester les changements apportés à un livrable par un nouveau prototype 
- on peut déterminer très rapidement l'introduction de bugs dans un projet

## Mise en oeuvre

L'idée de l'approche CI/CD est ainsi d'associer chaque changement de 
code (`commit`) à l'exécution de scripts automatisés

# Valoriser son projet avec un site web automatisé
