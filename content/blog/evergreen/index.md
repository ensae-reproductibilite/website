---
author: Alison Hill
categories:
- evergreen
date: "2021-01-20"
draft: false
excerpt: Good stuff
layout: single
subtitle: Testing
title: An evergreen post
---

## Rendering mathematical equations

Examples from the [mathjax demo](https://www.mathjax.org/#demo).
But they work with `katex` as well.

### Rmarkdown

In `.Rmarkdown` documents, you can use either

```
$a \ne 0$
```

to get inline math: `\(a \ne 0\)`.
There is no conflict with using dollar symbols regularly, because `knitr` automatically escapes freestanding dollar symbols.

And you can use

```
$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$
```

to get a math paragraph:

$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$

### md

In `.md` documents, you can **not** use the single dollar syntax.
The double dollar syntax still gives you a math paragraph.

```
$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$
```

$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$

In order to get inline equations, use:

```
`\(a \ne 0\)`
or
\\(a \ne 0\\)
```

to get: `\(a \ne 0\)`.



