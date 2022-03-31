---
title: "Structuration et qualité du code"
date: 2022-03-03
author: "Romain Avouac et Lino Galiana"
draft: false
# layout options: single, single-sidebar
layout: single
---


# Introduction

## L'enjeu d'un code lisible et maintenable

> The code is read much more often than it is written.
>
> <div title="Guido Van Rossum est le créateur de Python, c'est donc quelqu'un qu'il vaut mieux écouter">Guido Van Rossum</div>

Lorsque l'on s'initie à la pratique de la *data science*, il est assez naturel de voir le code d'une manière très fonctionnelle : je veux réaliser une tâche donnée — par exemple un algorithme de classification — et je vais donc assembler dans un *notebook* des bouts de code, souvent trouvés sur internet, jusqu'à obtenir un projet qui réalise la tâche voulue. La structure du projet importe assez peu, tant qu'elle permet d'importer correctement les données nécessaires à la tâche en question. Si cette approche flexible et minimaliste fonctionne très bien lors de la phase d'apprentissage, il est malgré tout indispensable de s'en détacher à progressivement à mesure que l'on progresse et que l'on peut être amené à réaliser des projets plus professionnels ou bien à intégrer des projets collaboratifs.

En particulier, il est important de proposer, parmi les multiples manières de résoudre un problème informatique, une solution qui soit intelligible par d'autres personnes parlant le langage. Le code est en effet lu bien plus souvent qu'il n'est écrit, c'est donc avant tout un outil de communication. De même, la maintenance d'un code demande généralement beaucoup plus de moyens que sa phase de développement initial, il est donc important de penser en amont la qualité de son code et la structure de son projet de sorte à le rendre au maximum maintenable dans le temps. Afin de faciliter ces réflexions, des tentatives plus ou moins institutionnalisées de définir des conventions ont émergé. Ces conventions dépendent naturellement du langage utilisé, mais les principes sous-jacents s'appliquent de manière universelle à tout projet basé sur du code.

## De l'importance de suivre les conventions

`Python` est un langage très lisible.
Avec un peu d’effort sur le nom des objets,
sur la gestion des dépendances et sur la structure du programme,
on peut très bien comprendre un script sans avoir besoin de l’exécuter.
C'est l'une des principales forces du langage `Python` qui permet ainsi
une acquisition rapide des bases.
`R`, dans sa version de base, est un langage un peu plus verbeux que
`Python`.
Cependant, les packages les plus utiles pour l'analyse de données (notamment
`dplyr` ou `data.table`) offrent une grammaire un peu plus transparente.

La communauté `Python` a abouti à un certain nombre de normes,
dites `PEP` (_Python Enhancement Proposal_),
qui constituent un standard dans l’écosystème Python.
Les deux normes les plus connues sont la norme `PEP8` (code)
et la norme `PEP257` (documentation).

Dans l'univers `R`, la formalisation
a été moins organisée. Ce langage est plus permissif que `Python`
sur certains aspects[^1].
Néanmoins, des standards ont émergé, à travers
un certain nombre de _style guides_ dont les plus connus
sont le
[_tidyverse style guide_](https://style.tidyverse.org/googl) et le
[_google style guide_](https://google.github.io/styleguide/Rguide.html)[^2]
(voir [ce post](https://blog.r-hub.io/2022/03/21/code-style/) qui pointe vers
un certain nombre de ressources sur le sujet).

Ces conventions ne sont pas immuables: les langages et leurs usages
évoluent, ce qui nécessite de mettre à jour les conventions. Cependant,
adopter dans la mesure du possible certains des réflexes préconisés par ces
conventions devrait améliorer la capacité à être compris par la communauté,
augmenter les chances de 
bénéficier d'apport de celle-ci pour adapter le code mais aussi réduire la 
difficulté à faire évoluer un code.
Il existe beaucoup de philosophies différentes sur le style de codage et,
en fait, le plus important est
la cohérence :
si on choisit une convention, par exemple _snake case_ plutôt que
_camel case_, le mieux est de s'y tenir. 

[^1]: Par exemple, en `R`, il est possible d'utiliser `<-` ou `=`
pour l'assignation,
on ne recontre pas d'erreur en cas de mauvaise indentation...

[^2]: Il existe d'autres guides de style notamment le [MLR style guide](https://github.com/mlr-org/mlr3/wiki/Style-Guide#theoretical-style-guide)
qui est un _framework_ orienté objet de _Machine Learning_ en `R`.


Les conventions vont au-delà de la syntaxe. Un certain nombre de standards
d'organisation d'un projet ont émergé.
La structuration d'un projet
permet d'immédiatement identifier les éléments de code et les éléments
annexes (par exemple les dépendances à gérer, la documentation, etc.).
Un certain nombre d'assistants au développement de projets orientés données
(des packages d'_helpers_, des extensions aux environnements
de développement comme `VisualStudio` ou `RStudio`...) ont 
émergé pour gagner en productivité et faciliter le
lancement d'un projet (voir
[ce post très complet sur les extensions VisualStudio](https://realpython.com/advanced-visual-studio-code-python/)). 
L'idée générale est de privilégier une structure de projet
bien plus fiable qu'une suite sans structure de scripts
ou un notebook jupyter (voir [ce post de blog sur ce sujet](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/)).

## Comment adopter ces bonnes pratiques ?

Les éléments exposés dans ce chapitre ne sont pas exhaustifs. Ils visent à pointer vers quelques problématiques prioritaires tout en proposant des conseils pratiques. Ils sont complémentaires du [guide des bonnes pratiques `utilitR`](https://www.pratiques.utilitr.org) qui vise à présenter de manière plus formelle quelques recommendations.

Dans la lignée de la vision des bonnes pratiques comme continuum proposée en [introduction]({{< ref "/content/introduction.md" >}}), il n'est pas nécessairement souhaitable d'appliquer toutes les recommendations présentées dans ce chapitre à chaque projet. Nous recommandons de les voir plutôt comme des bonnes habitudes à acquérir en opérant un va-et-vient régulier entre la pratique et la théorie. Par exemple, à la lecture de ce chapitre, vous allez certainement retenir en particulier certaines règles qui tranchent avec vos pratiques actuelles. Vous pouvez alors essayer d'appliquer ces nouvelles règles pendant un certain temps puis, lorsque celles-ci seront devenues naturelles, revenir à ce guide et appliquer le processus à nouveau. En procédant ainsi de manière incrémentale, vous améliorerez progressivement la qualité de vos projets sans avoir l'impression de passer trop de temps sur des micro-détails, au détriment des objectifs globaux du projet.

# 1. Qualité du code

## Principes généraux


Les premières conventions à évoquer ont trait à la syntaxe du code et
ont les objectifs suivants, qui seront détaillés par la suite :

- [Améliorer la lisibilité](#lisibilite) ce qui est indispensable pour
rendre la démarche intelligible par d'autres mais aussi pour soi, lorsqu'on
reprend un code écrit il y a quelques temps ;
- [Favoriser la concision](#concision) pour réduire le risque d'erreur
et rendre la démarche plus claire ;
- Suivre les règles explicites ou les conventions d'un langage pour
[assurer le fonctionnement et la cohérence](#coherence) d'un code ;
- [Limiter la redondance](#redondance) ce qui permet de simplifier
un code (paradigme du _don't repeat yourself_) ;
- [Documenter un code](#documentation) ce qui facilite son acquisition
par d'autres (à condition de ne pas aller dans l'excès de documentation).


### Lisibilité  {#lisibilite}

Un code écrit avec des noms de variables et de fonctions explicites est autant,
voire plus, informatif que les commentaires qui l’accompagnent.
C’est pourquoi il est essentiel de respecter des conventions pour le
choix des noms des objets afin d’assurer la lisibilité des programmes.


{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

Un certain nombre de conseils sont présents dans le [Hitchhiker's Guide to Python](https://docs.python-guide.org/writing/style/)
qui vise à faire connaître les préceptes du _"Zen of Python"_ (PEP 20).
[Ce post de blog](https://towardsdatascience.com/the-zen-of-python-a-guide-to-pythons-design-principles-93f3f76d088a) illustre quelques uns
de ces principes avec des exemples.
Vous pouvez retrouver ces conseils dans `Python` en 
tapant le code suivant:

```python
import this
```

```
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```



Voici quelques conseils complémentaires. 

- Adopter les mêmes standards que la communauté pour les noms de package

```python
# bien
import numpy as np

# trompeur
import numpy as pd
```

- Faire attention aux _namespaces_ pour éviter les conflits entre fonctions.
Cela implique de ne pas importer l'ensemble des fonctions d'un package de
la manière suivante:

```python
from numpy import *
from math import *
```

Dans ce cas, on va se retrouver avec des conflits potentiels entre les
fonctions du package `numpy` et du package `math` qui portent le même
nom (`floor` par exemple). 


{{% /panel %}}
{{% panel name="R" %}}

- Les fonctions de base `R` utilisent des points dans les noms de fonctions
(`contrib.url()` par exemple) ou les noms de classes (`data.frame`).
Il est mieux de réserver les points uniquement aux objets de classe `S3`
sous la forme `fonction.classe` (approche de programmation orientée objet).

- Privilégier le _snake case_, (écriture avec des *underscores*, par exemple `donnees_menages`)
au _CamelCase_
(écriture avec des majuscules en début de nouveau mot, par exemple `donneesMenages`)
(préconisation du [tidyverse style guide](https://style.tidyverse.org/syntax.html)).
Si vous préférez le _CamelCase_, utilisez-le systématiquement dans tout le script pour uniformiser le code.

- Ne pas utiliser `T` ou `F` pour nommer des variables
(car en plus d'être rarement des noms explicites ce sont les abréviations des booléens `TRUE` et `FALSE`)

- Ne pas utiliser de noms qui sont déjà des fonctions de base `R` (`mean` par exemple).
Cela ne génère pas toujours d'erreur mais cela évite des erreurs difficilement détectables! Voici un exemple d'erreur difficile à détecter:

```r
# On commence avec équivalence TRUE et T
TRUE == T
2 == TRUE
# On crée une variable T à un moment (shortcut de TRUE)
T <- 2
# On a rompu l'équivalence entre T et TRUE
TRUE == T
2 == T
```

- Le `return` n'est pas obligatoire en `R` mais il peut être utile
d'expliciter l'objet retourné.
Le [tidyverse style guide](https://style.tidyverse.org/functions.html#return)
recommande de ne pas le faire, le [Google style guide](https://google.github.io/styleguide/Rguide.html#use-explicit-returns)
recommande de toujours expliciter. Nous recommandons de toujours mettre un
`return`.
{{% /panel %}}
{{< /panelset  >}}

En complément de ces premières recommandations, il est conseillé
de suivre ces deux principes lorsqu'on commence à programmer
des fonctions (ce qui, comme cela est évoqué plus bas, est
toujours recommandé).

- Faire attention au type d'objet renvoyé par `Python` ou `R`.
Ces deux langages ne proposent pas de typage
fort,
il est donc possible qu'une fonction renvoie des objets de nature différente
en fonction, par exemple,
de conditions `if` (selon les cas une liste, un vecteur,
un dataframe, etc.). Cela peut amener à des surprises lorsqu'on utilise une 
telle fonction dans un code. Il est recommandé d'éviter ce comportement
en proposant des fonctions différentes si l'_output_ d'une fonction
est de nature différente. Ce principe de précaution (mais aussi d'information)
renvoie au paradigme de
la [programmation défensive](https://en.wikipedia.org/wiki/Defensive_programming).

- Privilégier la programmation orientée objet lorsqu'une fonction doit
s'adapter au type d'objet en entrée (par exemple aller chercher des
éléments différents pour un objet `lm` ou un objet `glm`).
Cela évite les codes _spaghetti_ :spaghetti: inutilement complexes qui sont impossibles à débugger.

{{% box status="hint" title="Hint" icon="fa fa-lightbulb" %}}

`Python` propose une fonctionalité assez plaisante qui est
le _`type hinting`_
([doc officielle](https://docs.python.org/3/library/typing.html)
et [tutoriel sur realpython.com](https://realpython.com/lessons/type-hinting/)).
Celle-ci permet d'indiquer le type d'argument attendu par une fonction
et celui qui sera renvoyé par la fonction. Par exemple, la personne ayant écrit la fonction suivante 

```python
def calcul_moyenne(df: pd.DataFrame, col : str = "y") -> pd.DataFrame:
    return df[col].mean()
```

propose d'utiliser deux types d'inputs (un `DataFrame pandas` et une chaine de caractère) et indique qu'elle renverra un `DataFrame pandas`. A noter que c'est indicatif, non contraignant. En effet, le code ci-dessus fonctionnera si on fournit en argument `col` une liste puisque `pandas` sait gérer cela à l'étape `df[col].mean()`

{{% /box %}}

<br>

{{% box status="note" title="Note: le code spaghetti :spaghetti: " icon="fa fa-comment" %}}
Le code `spaghetti` est un style d'écriture qui favorise l'apparition du syndrome du plat de spaghettis : 
un code impossible à déméler parce qu'il fait un usage excessif de conditions, d'exceptions en tous sens, de gestion des événements complexes. Il devient quasi-impossible de savoir quelles ont été les conditions à l'origine de telle ou telle erreur sans exécuter ligne à ligne (et celles-ci sont excessivement nombreuses du fait de mauvaises pratiques de programmation) le programme. 

En fait, la programmation spaghetti qualifie tout ce qui ne permet pas de déterminer le qui, le quoi et le comment. Le code est donc plus long à mettre à jour car cela nécessite de remonter un à un le fil des renvois.

{{% /box %}}

### Concision  {#concision}

Comme une démonstration mathématique, un code intelligible 
doit viser la concision et la simplicité. Les codes très longs
sont souvent signes de répétitions et sont difficiles à débugger. 

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

- Privilégier les `list comprehensions` lorsque cela est possible:

```python
liste_nombres = range(10)

# très mauvais
y = []
for x in liste_nombres:
  y.append(x*x)

# mieux
y = [x*x for x in liste_nombres]
```

- Privilégier les appels à des fonctions à des blocs 
copier-coller
en changeant un seul détail. 

{{% /panel %}}

{{% panel name="R" %}}

- Le code `R` base ci-dessous est très difficile à comprendre ;
- Le code `dplyr` est plus intelligible mais est encore relativement verbeux ;
- Le code `data.table` est plus concis, ce qui le rend plus clair (et plus
proche de la syntaxe SQL).

<table class='table' style = "width : 70%;">
<tr> <td>

**`Base R`**

</td> 
<td>

```r
aggregate(
  dt[dt[["x"]] > 3]$y,
  by = list(dt[dt[["x"]] > 3]$z),
  FUN = sum)
```

</td>
</tr>
<tr>
<td>

**`dplyr`**

</td> 
<td>

```r
dt %>%
  dplyr::filter(x > 3) %>%
  dplyr::group_by(z) %>%
  dplyr::summarise(sum(y))
```

</td>
</tr>
<tr>
<td>

**`data.table`**

</td> 
<td>

```r
dt[x > 3, sum(y), by = z]
```
</td>
</tr>
</table>

{{% /panel %}}
{{< /panelset >}}


### Cohérence interne {#coherence}

Lister les dépendances est important,
tant pour des raisons techniques (que le logiciel sache où aller
chercher des fonctions nécessaires pour avoir un code fonctionnel)
que pour des raisons conventionnelles (que les utilisateurs comprennent les
dépendances à s'installer pour être en mesure de réutiliser le code). 

Pour cette raison, il est de bonne pratique de lister les dépendances
de deux manières.

:one: En début de script, l'ensemble des fonctions issues de librairies externes
ou les packages à importer doivent être listés ;

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

Les imports se mettent conventionnellement en début de script, qu'il s'agisse d'import de packages dans leur ensemble ou seulement de certaines fonctions:

```python
import pandas as pd
from sklearn.model_selection import cross_val_score
```

Dans le premier cas, on fait ensuite référence aux fonctions en les faisant 
précéder du nom du package :

```python
pd.DataFrame([0,1])
```

Cela permet de dire à `Python` d'aller chercher dans le _namespace_ `pd` (alias pour `pandas` qui est lui-même un ensemble de scripts enregistrés sur le disque) la fonction `DataFrame`.

{{% /panel %}}

{{% panel name="R" %}}

`R` ne permet que l'import de la librairie dans son ensemble (sauf dans les _packages_, nous verrons cela plus tard).

```r
library(data.table)
```

Ensuite, on peut faire référence directement aux fonctions du package, par exemple `data.table`. Cependant, il est recommandé de privilégier la notion `pkg::function` (ici `data.table::data.table`) qui permet à `R` d'être certain d'aller chercher la fonction dans le bon _namespace_

{{% /panel %}}
{{< /panelset >}}

:two: Dans un fichier externe (voir la [partie structure](#structure) et le chapitre portabilité),
les dépendances à installer sont listées.

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

Il s'agit du fichier `requirements.txt`

{{% /panel %}}

{{% panel name="R" %}}

Il s'agit du fichier `DESCRIPTION`

{{% /panel %}}
{{< /panelset >}}


Un code reproductible doit pouvoir s'exécuter de manière linéaire.
S'il provoque une erreur, il est important de pouvoir identifier
l'instruction responsable pour pouvoir _debugger_.

Les scripts trop longs ne sont pas une bonne pratique. Il est préférable
de diviser l'ensemble des scripts exécutant une
chaîne de production en "monades"", c'est-à-dire en petites unités
cohérentes. Les fonctions sont un outil privilégié pour cela
(en plus de limiter la redondance, et d'être un outil privilégié
pour documenter un code).


### Limiter la redondance {#redondance}

Un bon principe à suivre est _"don't repeat yourself !"_ (DRY).
Celui-ci réduit la charge de code à écrire, à comprendre et à 
tenir à jour. 

{{< tweet 598532170160873472 >}}

Ce [post](https://www.earthdatascience.org/courses/intro-to-earth-data-science/write-efficient-python-code/intro-to-clean-code/dry-modular-code/) donne quelques bonnes pratiques
pour réduire la redondance des codes. 

Supposons qu'on dispose d'une table de données qui utilise le code `−99` pour représenter les valeurs manquantes. On désire remplacer l'ensemble des `−99` par des `NA`.

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

```python
# On fixe la racine pour être sûr de tous avoir le même dataset
np.random.seed(1234)

# On créé un dataframe
a = np.random.randint(1, 10, size = (5,6))
df = np.insert(
    a,
    np.random.choice(len(a), size=6),
    -99,
)
df = pd.DataFrame(df.reshape((6,6)), columns=[chr(x) for x in range(97, 103)])
```

{{% /panel %}}

{{% panel name="R" %}}

```r
# On fixe la racine pour être sûr de tous avoir le même dataset
set.seed(1014)

# On créé un dataframe
df <- data.frame(replicate(6, sample(c(1:10, -99), 6, rep = TRUE)))
names(df) <- letters[1:6]
```


{{% /panel %}}
{{< /panelset >}}

Un premier jet de code pourrait prendre la forme suivante:

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

```python
# Dupliquer les données
df2 = df.copy()
# Remplacer les -99 par des NA
df2.loc[df2['a'] == -99,'a'] = np.nan
df2.loc[df2['b'] == -99,'b'] = np.nan
df2.loc[df2['c'] == -99,'c'] = np.nan
df2.loc[df2['d'] == -99,'d'] = np.nan
df2.loc[df2['e'] == -98,'e'] = np.nan
df2.loc[df2['f'] == -99,'e'] = np.nan
```

{{% /panel %}}

{{% panel name="R" %}}

```r
# Dupliquer les données
df2 <- df
# Remplacer les -99 par des NA
df2$a[df2$a == -99] <- NA
df2$b[df2$b == -99] <- NA
df2$c[df2$c == -99] <- NA
df2$d[df2$d == -99] <- NA
df2$e[df2$e == -98] <- NA
df2$f[df2$e == -99] <- NA
df2
```


{{% /panel %}}
{{< /panelset >}}

Quelles sont les choses qui vous dérangent dans le code ci-dessus? Indice: regardez précisément le code et le dataframe (indice: surveillez la colonne `e` et la colonne `g`).

On peut noter au moins deux problèmes:

* Le code est long et répétitif, ce qui nuit à sa lisibilité;
* Le code est très dépendant de la structure des données (nom et nombre de colonnes) et doit être adapté dès que celle-ci évolue;
* On a introduit une erreur humaine dans le code, difficile à détecter, dans l'instruction concernant la colonne `e`. 

On voit dans la première version de notre code qu'il y a une structure commune à toutes nos lignes de la forme `.[. == -99] <- NA`. Cette structure va servir de base à notre fonction, en vue de généraliser le traitement que nous voulons faire.

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

```python
def fix_missing(x: pd.Series):
    x[x == -99] = np.nan
    return x

df2 = df.copy()
df2['a'] = fix_missing(df['a'])
df2['b'] = fix_missing(df['b'])
df2['c'] = fix_missing(df['c'])
df2['d'] = fix_missing(df['d'])
df2['e'] = fix_missing(df['e'])
df2['f'] = fix_missing(df['f'])
```

{{% /panel %}}

{{% panel name="R" %}}

```r
fix_missing <- function(x) {
  x[x == -99] <- NA
  x
}
df2 <- df
df2$a <- fix_missing(df2$a)
df2$b <- fix_missing(df2$b)
df2$c <- fix_missing(df2$c)
df2$d <- fix_missing(df2$d)
df2$e <- fix_missing(df2$e)
df2$f <- fix_missing(df2$f)
df2
```

{{% /panel %}}
{{< /panelset >}}

Cette seconde version du code est meilleure que la première version, car on a réglé le problème d'erreur humaine (il n'est plus possible de taper `-98` au lieu de `-99`). Mais le code reste long et répétitif, et n'élimine pas encore toute possibilité d'erreur, car il est toujours possible de se tromper dans le nom des variables. 

La prochaine étape est ainsi d'éliminer ce risque d'erreur en combinant deux fonctions (ce qu'on appelle combinaison de fonctions). La première `fix_missing()` sert à régler le problème sur un vecteur. La seconde généralisera ce procédé à toutes les colonnes. Comme `R` est un langage vectoriel, c'est une approche fréquente de construire des fonctions sur des vecteurs et les appliquer ensuite à plusieurs colonnes.


{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

```python
def fix_missing(x: pd.Series):
    x[x == -99] = np.nan
    return x
df2 = df.copy()
df2 = df2.apply(fix_missing)
```

{{% /panel %}}

{{% panel name="R" %}}

Il est possible d'appliquer `lapply` à un `dataframe` car un `dataframe` est en fait une liste de vecteurs (les colonnes du `dataframe`). Toutefois, comme `lapply` renvoie une liste, on a besoin d'utiliser une petite astuce pour s'assurer que la sortie de la fonction prenne la forme d'un `dataframe` et non d'une liste. A la place d'assigner le résultat sous la forme `df <- lapply(.....)` on va faire `df[] <- lapply(...)`. Ecrivez la boucle `lapply` permettant d'appliquer `fix_missing` a l'ensemble des colonnes du *dataframe*:

```r
df2 <- df
# Définir une fonction
fix_missing <- function(x) {
  x[x == -99] <- NA
  x
}
# Appliquer la fonction à toutes les colonnes du dataframe
df2[] <- lapply(df2, fix_missing)
df2
```

{{% /panel %}}
{{< /panelset >}}

Cette troisième version du code a plusieurs avantages sur les deux autres versions:

1. Elle est plus concise et plus lisible;
2. Si on a un changement de code pour les valeurs manquantes, il suffit de le mettre à un seul endroit;
3. Elle fonctionne quels que soient le nombre de colonnes et le nom des colonnes;
4. On ne peut pas traiter une colonne différemment des autres par erreur.

De plus, le code est facilement généralisable. Par exemple, à partir de la même structure, écrire le code qui permet de ne traiter que les colonnes *a*,*b* et *e*.

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

```python
df2 = df.copy()
df2[['a','b','e']] = df2[['a','b','e']].apply(fix_missing)
```

{{% /panel %}}

{{% panel name="R" %}}

```r
df2 <- df
df2[c("a","b","e")] <- lapply(c("a","b","e"), function(col) fix_missing(df2[col]))
```

{{% /panel %}}
{{< /panelset >}}



### Documentation {#documentation}

Un code sans aucun commentaire est très difficile à s'approprier (y compris
pour la personne qui l'a rédigé et qui y revient quelques semaines plus tard).
Cependant, un code présentant trop de commentaires est également illisible et
reflète généralement un défaut de conception du code qui n'est pas assez
explicite. 

La documentation vise à présenter la démarche générale, éventuellement
à travers des exemples, mais aussi à expliciter certains éléments
du code (une opération qui n'est pas évidente, des arguments de fonction, etc.). 
La documentation se mélange donc aux instructions visant à être exécutées
mais s'en distingue. Ces principes sont hérités du paradigme de la 
_"programmation lettrée"_ (_Literate programming_) dont l'un des 
avocats était Donald Knuth. 


> "Je crois que le temps est venu pour une amélioration significative de la documentation des programmes, et que le meilleur moyen d'y arriver est de considérer les programmes comme des œuvres littéraires. D'où mon titre, « programmation lettrée .
>
> Nous devons changer notre attitude traditionnelle envers la construction des programmes : au lieu de considérer que notre tâche principale est de dire à un ordinateur ce qu'il doit faire, appliquons-nous plutôt à expliquer à des êtres humains ce que nous voulons que l'ordinateur fasse.
>
> Celui qui pratique la programmation lettrée peut être vu comme un essayiste, qui s'attache principalement à exposer son sujet dans un style visant à l'excellence. Tel un auteur, il choisit , avec soin, le dictionnaire à la main, les noms de ses variables et en explique la signification pour chacune d'elles. Il cherche donc à obtenir un programme compréhensible parce que ses concepts sont présentés dans le meilleur ordre possible. Pour cela, il utilise un mélange de méthodes formelles et informelles qui se complètent"
>
> Donald Knuth, _Literate Programming_ ([source](https://fr.wikipedia.org/wiki/Programmation_lettr%C3%A9e))

Cela peut amener à distinguer deux types de documentation:

1. Une documentation générale de type `Jupyter Notebook` ou `R Markdown` qui 
présente certes du code exécuté mais dont l'objet principal est de présenter
une démarche ou des résultats
2. Une documentation de la démarche plus proche du code dont l'un des 
exemples sont les _docstrings_ `Python` ou la documentation `Roxygen`

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

- PEP 8, PEP 257


{{% /panel %}}

{{% panel name="R" %}}

L'exemple suivant, issu du livre de référence
d'Hadley Wickham et Jenny Bryan _R Packages_ permet de mesurer
l'intérêt de la documentation standardisée (bien-sûr ici la
fonction est assez explicite mais cela permet de se concentrer
sur la documentation). 

Les balises `Roxygen` s'insèrent autour de la définition d'une
fonction. Elles permettent à la lecture du code source de bien
comprendre l'objectif de la fonction ainsi que ses inputs. On
a même ici des exemples qui permettent de tester la fonction.

```r
#' Add together two numbers
#' 
#' @param x A number.
#' @param y A number.
#' @return The sum of \code{x} and \code{y}.
#' @examples
#' add(1, 1)
#' add(10, 1)
add <- function(x, y) {
  x + y
}
```

Ceci est déjà explicite à la lecture du code source. Cependant,
un avantage de cette structuration imposée de la documentation est
qu'ensuite, si la fonction est introduite dans un _package_,
la documentation de la fonction, accessible via `?add` par
exemple, est automatiquement mise en forme:

![](https://d33wubrfki0l68.cloudfront.net/b97dc657a7e1c7030d1b8d188723fb10f5260474/3dc52/images/man-add.png)

{{% /panel %}}
{{< /panelset >}}



## Standards communautaires de code

Pour parler le même langage, un certain nombre de conventions ont
émergé dans les communautés `R` et `Python`. L'objectif ici 
n'est pas de lister ces conventions (une partie d'entre elles ayant
déjà été évoquées) mais pointer rapidement vers les principales
conventions. 
Dans le domaine, `Python` a crée un système un peu plus formel que
`R` mais globalement, la démarche est la même. 

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

- PEP 8, PEP 257


{{% /panel %}}

{{% panel name="R" %}}

Les incontournables sont :

- [_tidyverse style guide_](https://style.tidyverse.org/googl)
- [_google style guide_](https://google.github.io/styleguide/Rguide.html)
* [Le guide du développeur Ropensci](https://devguide.ropensci.org/index.html)

`Ropensci` a également lancé un appel à contribution pour proposer
un guide des bonnes pratiques adapté aux projets de données 
gouvernementaux
[sur Github](https://github.com/ropensci-org/community-calls/issues/26).
L'OCDE devrait également lancer un manuel sur le sujet dans les prochains
mois. 

{{% /panel %}}
{{< /panelset >}}

## Outils et méthodes pour améliorer un code

### Helpers

`Python` ou `R` étant l'outil de travail principal de milliers de 
_data-scientists_, un certain nombre d'outils ont vu le jour
pour réduire le temps nécessaire pour créer un projet ou disposer
d'un code fonctionnel. Ces outils permettent un gros gain de productivité,
réduisent le temps passé à effectuer des tâches rébarbatives et améliorent
la qualité d'un projet en offrant des diagnostics voire des correctifs
à des codes perfectibles. 

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}


{{% /panel %}}

{{% panel name="R" %}}

La première chose à faire est de privilégier
les projets RStudio (
[voir la présentation de ceux-ci dans la documentation `utilitR`](https://www.book.utilitr.org/rproject.html)
et les éléments présentés dans la partie sur la
[structuration des projets](#structure)).

Les packages suivants font partie de la palette du développeur: 

* [`usethis`](https://usethis.r-lib.org/): s'il fallait n'en retenir qu'un (ce
qui serait tout de même un peu dommage...). Le couteau-suisse de la création
et de la gestion des options d'un projet
* [`devtools`](https://github.com/r-lib/devtools): le meilleur ami de la
personne qui développe les packages. Le livre [R Packages](https://r-pkgs.org/index.html)
donne de nombreux exemples à son propos. 
* [`here`](https://here.r-lib.org/): pour en finir avec la galère des chemins
relatifs, des dossiers de travail, etc.
* [`Roxygen`](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html): 
le package dédié à la documentation des fonctions
* [`goodpractice`](https://github.com/MangoTheCat/goodpractice): des diagnostics
pratiques sur la qualité du code

Enfin, `RStudio` propose de nombreux _addins_ (extensions) bien pratiques.
La plupart sont installés avec des _packages_ de _helpers_, n'hésitez
pas à en tester quelques uns. 

{{% /panel %}}
{{< /panelset >}}

### Analyse de code

-   linters
-   formatters

Les _linters_ sont des outils qui permettent d'évaluer la qualité du 
code et son risque de provoquer une erreur (explicite ou silencieuse).
Voici quelques exemples de problèmes que peuvent rencontrer les 
`linters`:

* les variables sont utilisées mais n'existent pas (erreur)
* les variables inutilisées (inutiles)
* la mauvaise organisation du code (risque d'erreur)
* le non respect des bonnes pratiques d'écriture de code
* les erreurs de syntaxe (par exemple les coquilles)
    
La plupart des logiciels de développement embarquent des fonctionalités
de diagnostic (voire de suggestion de correctif). Il faut parfois
les paramétrer dans les options (ils sont désactivés pour ne pas
effrayer l'utilisateur avec des croix rouges partout)

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}


{{% /panel %}}

{{% panel name="R" %}}

Les packages de référence dans le 
domaine sont:

- [`lintr`](https://github.com/r-lib/lintr) pour les diagnostics ;  
- [`styler`](https://github.com/r-lib/styler) pour la modification
automatisée des fichiers suite au diagnostic.

`RStudio` propose des diagnostics mais ils ne sont pas activés
par défaut. Pour les activer, après avoir fait `Tools > Global Options` : 

1. Aller dans la partie `Code` à gauche
2. Dans les onglets en haut, cliquer sur `Diagnostics`
3. Ajouter quelques diagnostics (par défaut ceux-ci sont vraiment
trop peu nombreux)

![](/rstudio-diagnostics.png)

Même si vous ne développez pas de _packages_ ces diagnostics vous
permettront d'améliorer la qualité de vos codes. 

{{% /panel %}}
{{< /panelset >}}

### Relecture par un tiers / pair-programming

# Structure des projets {#structure}

## Modularité

-   fonctions
-   modules

## Principes d'architecture

Comme `Git` est un pré-requis, tout projet présente un fichier `.gitignore`
(il est très important, surtout quand on manipule des données qui ne
devraient pas se retrouver sur `Github` ou `Gitlab`).

Les _output_ sont stockés dans un dossier séparé, de même que les _inputs_
(idéalement ils ne sont même pas stockés avec le code, nous reviendrons
sur la distinction code-stockage-exécution plus tard). Ne pas
oublier d'ajouter les dossiers ou extensions qui vont bien dans
le `.gitignore` pour ne pas les committer.

Idéalement, un projet utilise de l'intégration continue (voir partie XXX) : 

- si vous utilisez `Gitlab`, les instructions sont stockées dans
le fichier `gitlab-ci.yml`
- si vous utilisez `Github`, cela se passe dans le dossier `.github/workflows`



{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}


{{% /panel %}}

{{% panel name="R" %}}

La première recommandation (si ce n'est obligation) est de privilégier
les projets `RStudio`. Voici ce qu'en dit la 
[documentation collaborative `utilitR`](https://www.book.utilitr.org)

> Le principe d'un projet `RStudio` est de rassembler tous les éléments de contexte propres à ce projet : espace de travail, historique de commandes, variables d'environnement, options de `R`... Utiliser un projet `RStudio` présente donc de multiples avantages : 
> 
> * Il centralise l'ensemble des éléments d'un projet : codes, réglages, documentation, et sorties (articles, présentations) ;
> * Il facilite la compréhension du traitement pour les utilisateurs extérieurs et rend plus aisées les évolutions postérieures du projet ;
> * Il organise l'interaction entre les fichiers (plusieurs codes, rédaction de documents avec R markdown...) et avec les données ;
> * Il renforce la portabilité : le répertoire de travail par défaut d’un projet est le dossier où se situe le fichier `.Rproj`. Cela rend les scripts indépendants de l'arborescence de la machine. Ainsi, si vous avez un code `traitement.R` situé dans le même dossier que le fichier `.Rproj`, alors le chemin de ce code est `./traitement.R`, où que soit situé le dossier du projet.

Ensuite, il est important de privilégier les fonctions comme évoqué précédemment
afin d'avoir un fichier qui n'accumule pas 50 000 lignes de code 
pour l'ensemble du projet de données. Les fonctions sont stockés dans un 
ou plusieurs fichiers `R` (idéalement organisés de manière thématique en 
regroupant une ou plusieurs fonctions faisant des opérations proches). 
Supposons que le fichier qui les utilise s'appelle `main.R` [^1]
[^1]: Nous évoquerons plus tard le principe de `targets` qui permet d'avoir
un _pipeline_ de données plus fiable que cette méthode.

```
project
│   .gitignore    
│   .gitlab-ci.yml    
│   main.R   
│   README.md
│
└───input
│   │   source.csv
│
└───R
│   │   utils.R
│   │   figures.R
|   |   statsdesc.R
|   |   ...
│   
└───output
    │   superfigure.png
    │   agregat.csv
    |   ...

```


{{% /panel %}}
{{< /panelset >}}




### Séparation données/code/config/environnement d'exécution

### Modèles

-   input / traitement / output
-   domain-driven design (data, domain, application, presentation)

### Templates

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

-   Python : cookiescutter


{{% /panel %}}

{{% panel name="R" %}}

Dans l'ensemble, la structure d'un projet en `R` est une variation
sur le thème du projet `RStudio`. Ce qui en général
va distinguer les types différents projets est la présence
de fichiers à la racine ou dans un dossier `R/`

Il existe un certain nombre de _templates_ de projets. Ceux-ci
sont accessibles lorsqu'on créé un nouveau projet
via `File > New Project`:

![](/rstudio-templates.png)

- Les projets sous forme de 
packages permettent d'intégrer de manière cohérente un ensemble
de fonctions. Le package peut contenir exclusivement du code `R` 
ou du code `C++` (via `Rcpp`)
- Les projets sous forme de site web (`bookdown` pour la documentation,
`blogdown` pour des sites web plus généraux) gèrent la transformation
entre des fichiers sources `R Markdown` et un site web à l'arborescence 
cohérente. 
- Les projets `shiny` attendent une structure particulière pour gérer
l'interaction entre l'interface graphique et les calculs à effectuer
en réaction aux actions sur l'interface. Le _framework_ 
`golem` permet de formaliser
de manière plus propre les projets shiny

Le package `usethis` offre des fonctionalités pratiques pour enrichir 
un projet de nouvelles options
ou changer de type de projet en cours de route (par exemple basculer d'un
projet basique à un _package_). 

{{% /panel %}}
{{< /panelset >}}


## Packages

La meilleure façon d'assurer la reproductibilité d'un projet est
d'intégrer ses scripts dans une structure de _package_.
Un gros projet
de _data-science_ va ainsi dépendre d'un ou plusieurs _packages_, ce qui 

- assure une gestion cohérente des dépendances
- offre une certaine structure pour la documentation
- facilitera sa réutilisation (les utilisateurs peuvent n'être intéressés
que par une partie du projet)
- permettra des économies d'échelle (on peut réutiliser
l'un des packages pour un autre projet)
- facilite le debuggage (il est
plus facile d'identifier une erreur quand elle est dans un package)
- ...


### Gestion des dépendances

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

-   Python : cookiescutter


{{% /panel %}}

{{% panel name="R" %}}

Un projet utilise généralement un certain nombre de librairies 
externes. Dans le code, on utilise en général la syntaxe
`pkg::function` (syntaxe à préférer pour éviter toute ambiguité)
ou `library(pkg)`
puis `function`. Cependant, cela ne garantit pas que le code soit
fonctionnel: quelqu'un qui n'a pas installé les librairies en 
question se retrouvera avec une erreur. Il est donc nécessaire 
de lister les dépendances à installer si on désire
que le code tourne sans soucis. C'est le rôle du fichier `DESCRIPTION`

> The job of the `DESCRIPTION` file is to store important metadata
about your package.
> When you first start writing packages,
you’ll mostly use these metadata to record what packages are needed
to run your package.
> However, as time goes by, other aspects of the metadata file will
become useful to you,
such as revealing what your package does (via the Title and Description)
and whom to contact (you!) if there are any problems.
> 
> ...
>
> It’s the job of the DESCRIPTION to list the packages that
your package needs to work.
> R has a rich set of ways to describe different types of dependencies.
> A key point is whether a dependency is needed by regular users or is only
> needed for development tasks or optional functionality.
>
> Hadley Wickham et Jenny Brian, [_R Packages_](https://r-pkgs.org/description.html)

Le fichier `DESCRIPTION` a vocation à lister les dépendances nécessaires
à installer pour qu'un code soit fonctionnel. Initialement prévu pour
les _packages_, il est devenu plus courant de le trouver (à l'image
du `requirements` de `Python`).

En effet, quand
un projet comporte ce fichier, on peut installer l'ensemble des dépendances
listées dans le `DESCRIPTION` en une ligne, ce qui est bien pratique :

```r
devtools::install_deps()
```

Pour créer ce fichier, l'idéal est d'utiliser le package `usethis` qui
va initialiser ce fichier à partir d'un _template_:

```r
usethis::use_description(check_name = FALSE)
```

Dans ce fichier, les dépendances seront listées dans divers champs, en 
fonction du degré de dépendance du code à ces librairies (
pour simplifier, les _packages_ indispensables seront listés dans 
un champ `Imports`, ceux qui peuvent servir pour des éléments
annexes dans un champ `Suggests`)

```r
Imports:
    dplyr,
    tidyr
```

L'utilisateur qui fera `devtools::install_deps()` se retrouvera alors
à installer `dplyr` et `tidyr` s'il ne les a pas déjà. 


{{% /panel %}}
{{< /panelset >}}


### Documentation

### Logging

### Tests unitaires

{{< panelset class="nommage" >}}
{{% panel name="Python :snake:" %}}

-   Python : cookiescutter


{{% /panel %}}

{{% panel name="R" %}}

Le package [`testthat`](https://testthat.r-lib.org/) offre 
des fonctionalités très intéressantes pour les tests.
Le manuel [R Packages](https://r-pkgs.org/tests.html)
présente un certain nombre d'exemples.


{{% /panel %}}
{{< /panelset >}}

### Publication

Quand on débute, on est souvent timide et on désire ne rendre public
son code que lorsque celui-ci est propre. C'est une erreur classique:

{{< tweet 589068687669243905 >}}

Comme pour nettoyer un appartement, les petits gestes en continu
sont beaucoup plus efficace qu'un grand ménage de printemps.
Prendre l'habitude de mettre son code immédiatement sur `Github`
vous amènera à adopter de bons gestes. 

### Maintenance


L'objectif des conseils de ce cours est
de réduire le coût de la
maintenance à long terme en adoptant les structures
les plus légères, automatisées et 
réutilisables. 

Les notebooks Jupyter sont très pratiques pour tâtonner
et expérimenter. Cependant, ils présentent un certain
nombre d'inconvénients à long terme qui peuvent 
rendre impossible à maintenir le code écrit
avec dans un notebook:

- tous les objets (fonctions, classes et données)
sont définis et disponibles dans le même fichier.
Le moindre changement à une fonction nécessite de retrouver
l'emplacement dans le code, écrire et faire tourner à nouveau
une ou plusieurs cellules. 
- quand on tâtonne, on écrit du code dans des cellules. 
Dans un cahier, on utiliserait la marge mais cela n'existe
pas avec un notebook. On créé donc de nouvelles cellules, 
pas nécessairement dans l'ordre. Quand il est
nécessaire de faire tourner à nouveau le notebook, cela
provoque des erreurs difficile à debugger (il est nécessaire
de retrouver l'ordre logique du code, ce qui n'est pas
évident). 
- les notebooks incitent à faire des copier-coller de cellules
et modifier marginalement le code plutôt qu'à utiliser
des fonctions. 
- il est quasi-impossible d'avoir un versioning avec Git des notebooks
qui fonctionne. Les notebooks étant, en arrière plan, de gros fichiers
JSON, ils ressemblent plus à des données que des codes sources. Git ne
parvient pas à identifier les blocs de code qui ont changé
- passage en production des notebooks coûteux alors qu'un script bien
fait est beaucoup plus facile à passer en prod (voir suite cours)
- Jupyter manque d'extensions pour mettre en oeuvre les bonnes pratiques
(linters, etc.). VSCode au contraire est très bien 
- Risques de révélation de données confidentielles puisque les outputs
des blocs de code, par exemple les `head`, sont écrits en dur dans
le code source. 

Globalement, les notebooks sont un bon outil pour tâtonner ou pour
faire communiquer. Mais pour maintenir un projet à long terme, 
il vaut mieux privilégier les scripts. Les
recommandations de ce cours visent à rendre le plus léger possible
la maintenance à long terme de projets _data-science_ en favorisant
la reprise par d'autres (ou par soi dans le futur)

# Application: nettoyer et packager un projet de data science

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

0. :zero: Forker le dépôt et créer une branche de travail .
1. :one: S'assurer que le notebook `titanic.ipynb` s'exécute correctement.
2. :two: Mettre en fonctions les parties importantes de l'analyse (import des données, feature engineering, entraînement et évaluation du modèle) et mettre ces fonctions dans un module `functions.py`.
3. :three:  Créer un script `main.py` qui reproduit l'analyse de bout en bout sans passer par un notebook.
4. :four:  Appliquer les recommendations du linter `PyLint` aux scripts `main.py` et `functions.py`, viser une note minimale de 9/10 pour le premier et 6/10 pour le second.
5. :five: S'inspirer du cookiecutter datascience (template de projet) pour construire une structure de package.
6. :six: Exporter l'environnement Conda pour favoriser la portabilité du projet.
7. :seven: Mettre les données dans son bucket personnel sur le stockage MinIO du SSP Cloud et adapter la fonction d'import de données.



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




<!----
# Application sur un projet personnel

{{% box status="exercise" title="Application" icon="fas fa-pencil-alt" %}}

Sur un projet personnel, terminé ou en cours :

-   utiliser un linter pour améliorer la qualité du code au maximum (seuil ?)

-   modulariser le code

    -   réécrire le code sous forme de fonctions
    -   répartir les fonctions dans des modules thématiques
    -   écrire un script `main.py` qui permet de reproduire le projet

-   choisir une architecture cohérente de projet

-   faire du projet un package

{{% /box %}}
----->


# Références

- [The Hitchhiker’s Guide to Python](https://docs.python-guide.org/#writing-great-python-code)
- [_tidyverse style guide_](https://style.tidyverse.org/googl)
- [_google style guide_](https://google.github.io/styleguide/Rguide.html)
- [Cours de Pierre-Antoine Champin](https://perso.liris.cnrs.fr/pierre-antoine.champin/enseignement/algo/cours/algo/bonnes_pratiques.html)
- [R Packages](https://r-pkgs.org/index.html) par Hadley Wickham and Jenny Bryan
- [La documentation collaborative `utilitR`](https://www.book.utilitr.org)
- [Project Oriented Workflow](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/)
- [Un post très complet sur les extensions VisualStudio](https://realpython.com/advanced-visual-studio-code-python/)
- ["Coding style, coding etiquette"](https://blog.r-hub.io/2022/03/21/code-style/)
