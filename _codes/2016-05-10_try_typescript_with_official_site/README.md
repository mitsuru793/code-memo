---
layout: code
title: 公式サイトを参考にTypeScriptを初めてさわってみた感想
date: 2016-05-10 17:34:11 +0900
tags: [typescript, javascript]
---

コンパイル時に型でエラーが出せるのがいいなと思いました。今回は[公式サイトのチュートリアル](https://www.typescriptlang.org/docs/tutorial.html)から手をつけました。

# setup

```
npm install -g typescript
cd src
tsc -w * --outDir ../dist
```

# interfaceがコンパイル後のソースコードに影響を与えない

`let num: number = 1`という書き方もですが、`interface`を使った場合もコンパイル後のソースコードに影響を与えません。`: number`や`interface`の部分は取り除かれます。コンパイル時だけ使われるようです。そのため、型だけ使うならいつでもTypeScriptを離れることができますね。

`interface`はとりあえずこういうプロパティ名を管理したいという下書きみたいに使えるのが良いですね。`options = {}`と1つの引数で複数のオプションを渡せるようにしていましたが、これだと何のオプションが選択可能かわかりずらいです。これを`interface`として定義しておけば見通しが良くなると思います。

```javascript
class Student {
  fullName: string;
  constructor(public firstName, public middleInitial, public lastName) {
    this.fullName = firstName + " " + middleInitial + " " + lastName;
  }
}

interface Person {
  firstName: string;
  lastName: string;
}

function greeter(person: Person) {
  return "Hello, " + person.firstName + " " + person.lastName;
}

var user = new Student("Jane", "M.", "User");
document.body.innerHTML = greeter(user);
```

```javascript
var Student = (function () {
    function Student(firstName, middleInitial, lastName) {
        this.firstName = firstName;
        this.middleInitial = middleInitial;
        this.lastName = lastName;
        this.fullName = firstName + " " + middleInitial + " " + lastName;
    }
    return Student;
}());
function greeter(person) {
    return "Hello, " + person.firstName + " " + person.lastName;
}
var user = new Student("Jane", "M.", "User");
document.body.innerHTML = greeter(user);
```

# 定数をまとめるならenumを使う

フラグ管理に重宝しそうです。定数を管理するための`interface`という感じがしました。`enum`にはインデックスでもラベルでもアクセスできるのが凄いです。`var current = status.poison`とラベルでセットすることもできますし、`rate[0]`で`"悪い"`を取得したりと段階に対応したラベルを取得とかに使おうかな。

```javascript
enum Color {Red, Green, Blue};
let c: Color = Color.Green;
console.log(Color); // Object {0: "Red", 1: "Green", 2: "Blue", Red: 0, Green: 1, Blue: 2}
console.log(Color[0]); // Red
console.log(Color.Red); // 0
console.log(Color['Red']); // 0
```

`Color[Color["Red"] = 0] = "Red";`は、`Color["Red"] = 0`で`0`が評価値になるので最終的には`Color[0] = "Red";`という形になります。1行で2つのプロパティを作るのは面白い書き方です。

即時関数の引数`(Color || (Color = {})`ですが、`Color ||`としていることで、`Color`を拡張できるようにしていますね。もう一度`enum Color`と書けばプロパティを追加できます。

```javascript
var Color;
(function (Color) {
    Color[Color["Red"] = 0] = "Red";
    Color[Color["Green"] = 1] = "Green";
    Color[Color["Blue"] = 2] = "Blue";
})(Color || (Color = {}));
;
var c = Color.Green;
console.log(Color); // Object {0: "Red", 1: "Green", 2: "Blue", Red: 0, Green: 1, Blue: 2}
console.log(Color[0]); // Red
console.log(Color.Red); // 0
console.log(Color['Red']); // 0
```

# voidはundefinedとnullを表す型

関数の戻り値の型に`void`を使うと、戻り値がないことを示すとありました。JavaScriptは`return`を明示的に書かないと`undefined`を返します。つまり、`void`で`undefined`を返すかをチェックしています。これは関数だけでなく、変数の型にも使えますが使い道は思いつきませんでした。

```javascript
function warnUser(): void {
 console.log("This is my warning message");
}
let unusable: void = undefined;
unusable = null;
```

# anyとキャストの使い道がわからない

型に`object`ではなく、`any`を指定すると何のメソッドを指定しても警告が出ません。何でも許容するということです。`any`型を他の型にするには`<string>myVal`のようにキャストするのですが、しなくても警告なしで代入できました。キャストさせてメソッド呼び出しで警告を出すようにするのかな。イマイチ使い方がわかりませんでした。

```javascript
let someValue: any = "this is a string";
let strLength: number = (<string>someValue).length;
```

# 内側と外側のスコープで同名の変数は、同スコープに持ってきも別扱いになる。

サンプルで面白いコードがありました。よく考えれば複数のDOMにループでイベントハンドラをセットするのと同じです。

```javascript
function outer() {
  var a = 1;

  a = 2;
  var b = inner();
  a = 3;

  return b;
  function inner() {
    return a;
  }
}

console.log("outer() : " + outer()); // 2
```

# functionを書かずに済むlet

`let`を使うと関数スコープからブロックスコープに変更することができます。クロージャのために関数を書かなくて済みます。もう常に`var`ではなく、`let`を使うようにすれば良い気がしました。

```javascript
for (let i =0; i < 10; i++) {
  setTimeout(function() {console.log(i);}, 100 * i);
}
```

```javascript
var _loop_1 = function(i) {
    setTimeout(function () { console.log(i); }, 100 * i);
};
for (var i = 0; i < 10; i++) {
    _loop_1(i);
}
```
