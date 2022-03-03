---
author: Alison Hill
categories:
- Theme features
date: "2021-01-02"
draft: false
excerpt: Add tabbed sections to your posts.
layout: single
subtitle: How to add panelsets in plain markdown posts.
title: Using panelsets
---

Courtesy of panelset.js by Garrick Aden-Buie, from his xaringanExtra package: https://pkg.garrickadenbuie.com/xaringanExtra/#/panelset

For example, this panelset:

{{< panelset class="greetings" >}}
{{< panel name="Hello! :wave:" >}}
  hello
{{< /panel >}}
{{< panel name="Goodbye :dash:" >}}
  goodbye
{{< /panel >}}
{{< /panelset  >}}

Was created by combining this theme's `panelset` and `panel` shortcodes:

```go
{{</* panelset class="greetings" */>}}
{{</* panel name="Hello! :wave:" */>}}
  hello
{{</* /panel */>}}
{{</* panel name="Goodbye :dash:" */>}}
  goodbye
{{</* /panel */>}}
{{</* /panelset */>}}
```


You could also revert to HTML as well. For example, this panelset:


<div class="panelset">
  <div class="panel">
    <div class="panel-name">Question</div>
    <!-- Panel content -->
    <p>Which came first: the :chicken: or the :egg:?</p>
  </div>
  <div class="panel">
    <div class="panel-name">Answer :hatching_chick:</div>
    <!-- Panel content -->
    <p>Team :egg: FTW!</p>
  </div>
</div>

Was created with this HTML code:

```html
<div class="panelset">
  <div class="panel">
    <div class="panel-name">Question</div>
    <!-- Panel content -->
    <p>Which came first: the :chicken: or the :egg:?</p>
  </div>
  <div class="panel">
    <div class="panel-name">Answer :hatching_chick:</div>
    <!-- Panel content -->
    <p>Team :egg: FTW!</p>
  </div>
</div>
```