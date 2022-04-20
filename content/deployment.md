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

- DAG

## Orchestration

## CI/CD
