---
layout: code
title: ライブラリを使わずに兄弟要素としてDOMを追加する関数
date: 2016-05-07 05:57:01 +0900
tags: [coffeesciprt]
---

`jQuery`などのライブラリを使わずに、兄弟要素としてDOMを追加する関数を書きました。

```html
<ul id="ul1">
  <li>1</li>
  <li>2</li>
  <li>3</li>
</ul>
```

```coffee
appendBefore = (element, insertElement) ->
  element.parentNode.insertBefore(insertElement, element)

appendAfter = (element, insertElement) ->
  element.parentNode.insertBefore(insertElement, element.nextSibling)

createLi = do ->
  liEl = document.createElement('li')
  (string) ->
    newLiEl = liEl.cloneNode(false)
    newLiEl.innerText = string
    newLiEl

lis = document.querySelectorAll('#ul1 > li')
appendBefore(lis[0], createLi('0'))
appendAfter(lis[0], createLi('1.5'))
```
