---
layout: code
title: CoffeeScriptで複数のliタグにclickイベントをセットする
date: 2016-05-07 02:13:11 +0900
tags: [coffeescript, javascript]
---

CoffeeScriptで`li`タグに`click`イベントを定義していきます。

```html
<ul id="hoge">
  <li>hoge1</li>
  <li>hoge2</li>
  <li>hoge3</li>
</ul>
```

```coffee
ul = document.getElementById('hoge')
for li in ul.querySelectorAll('li')
  li.addEventListener('click', (e) ->
    log(li.innerText)
  )
```

このやり方だと、どこをクリックしても`hoge3`と表示されてしまいます。イベントハンドラが発火した時には、`for`ループは既に回りきっているので変数`li`に`ul.querySelectorAll('li')`の一番最後の要素が入っています。

# 関数の中に関数を作ればクロージャ

まずはループを使わずにクロージャを定義してみます。

```coffee
outer = ->
  x = 1
  ->
    log("outer: " + x)
    x = x + 1

myFunc = outer()
myFunc()
myFunc()
myFunc()
```

```javascript
outer = function() {
  var x;
  x = 1;
  return function() {
    log("outer: " + x);
    return x = x + 1;
  };
};

myFunc = outer();
myFunc();
myFunc();
myFunc();
```

`myFunc`には、`outer`関数の戻り値である無名関数が入ります。なので`myFunc`を実行すると、`outer`関数の中の無名関数が実行されます。この時、次のように`x`は参照されます。

1. 無名関数内に`x`が定義されていない。
2. 外側のレキシカル(関数)スコープで`x`を探す。
3. `outer`関数の`x`を取得。

`outer`関数内の変数`x`は、内側のレキシカルスコープから参照されているのでこのスコープは破棄されず残り続けます。`myFunc`の実行が終っても、`x`が再定義されることはありません。維持されます。

JavaScriptは`{}`を使ったブロックスコープではなく、関数ごとにスコープが作られます。なので関数の中に、関数を作ればクロージャになります。そして内側から外側の変数を参照すれば良いのです。

# ループとsetTimeoutでクロージャを使う

```coffee
for i in [1..3]
  setTimeout(do (i) ->
    ->
      log("setTimeout1: " + i)
  , 200)
```

```javascript
for (i = n = 1; n <= 3; i = ++n) {
  setTimeout((function(i) {
    return function() {
      return log("setTimeout1: " + i);
    };
  })(i), 200);
}
```

CoffeeScriptでは`do`を使うと無名関数ができます。一緒に引数を指定すると、無名関数の定義場所の同名の変数が引数として渡されます。

* `for`ループの変数`i`が、`do`の仮引数`i`に渡される。
* `do`による無名関数で新たなレキシカルスコープが作られるので、新しい変数`i`が定義されることになる。

無名関数に出来た新たな変数`i`を内側から参照するために、`do`の中にさらに無名関数を作ります。

# liタグにイベントハンドラをセットする

上記のイベントハンドラの書き方を、最初に`li`タグの`click`イベントに使ってみます。

```coffee
ul = document.getElementById('hoge')
for li in ul.querySelectorAll('li')
  li.addEventListener('click', do (li) ->
    (e) ->
      log(li.innerText)
  )
```

```javascript
ul = document.getElementById('hoge');

ref1 = ul.querySelectorAll('li');
for (k = 0, len1 = ref1.length; k < len1; k++) {
  li = ref1[k];
  li.addEventListener('click', (function(li) {
    return function(e) {
      return log(li.innerText);
    };
  })(li));
}
```

`do`の無名関数に特に処理は必要ありません。メイン処理の関数を返すだけでいいです。保持したい変数も無名関数の仮引数で作られるので、記述する必要はありません。
