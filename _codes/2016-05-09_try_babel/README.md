---
layout: code
title: babelを使ってみる
date: 2016-05-09 18:14:43 +0900
tags: [babel]
---

webpackを使う前にbabelを試してみました。babelは最新のECMAのコードを古いJavaScriptにコンパイルしてくれるものです。新機能が普及する前から最新のコードに保つことができるので、書き直す必要はありません。

とりあえず、`module`の`export`さえ抑えておけばいいと思いました。

# setup

```
npm install --save-dev babel-cli
npm install --save-dev babel-preset-es2015
```

```json
{
  "name": "sample",
  "version": "1.0.0",
  "main": "Hello.js",
  "devDependencies": {
    "babel-cli": "^6.8.0",
    "babel-preset-es2015": "^6.6.0"
  },
  "scripts": {
    "build": "babel src -d lib",
    "watch": "babel -w src -d lib"
  }
}
```

# export

```javascript
export const CONST_VAL = "const val";

const _hello = function(name) {
  return "private:Hello, " + name
};

export const open_hello = function(name) {
  return "open:Hello, " + name
};

export _not_const_hello = function(name) {
  return "not const private:Hello, " + name
};

// export function _not_const_hello(name) {
//   return "not const private:Hello, " + name
// };

console.log("finish Hello.js")
```

```javascript
import {CONST_VAL, open_hello, _not_const_hello} from './Hello';
console.log(CONST_VAL);
console.log(open_hello("Mike"));
console.log(_not_const_hello("Jane"));

// is not defined
// console.log(_hello("Bob"));
```
# export default

```javascript
/* ReferenceError: People is not defined
export default People = {
  Mike: 19,
  Jane: 15
};
*/

export default {
  Mike: 19,
  Jane: 15
};

/* エラーにはならないがexportはできていない
export Food = {
  rice: 200,
  drink: 150
}
*/

/*
export const Food = {
  rice: 200,
  drink: 150
}
*/


import People, {Food} from './People';
console.log(People)
console.log(Food)
```

# class

```javascript
export default class People {
  constructor(name, age, from) {
    this.name = name;
    this.age  = age;
    this.from = from;
  }
  hello(toName) {
    return `Hello, ${toName}.`;
  }
  introduce() {
    return `I'm ${this.name}, ${this.age} and from ${this.from}`;
  }
}
```

```javascript
import People from './PeopleClass'

var person = new People('Bob', 19, 'Australia');
console.log(person.name);
console.log(person.hello('Mike'));
console.log(person.introduce());

class Japanese extends People {
  constructor(name, age) {
    super(name, age, 'Japan');
  }
}

var taro = new Japanese('Taro', 18);
console.log(taro.introduce());
```
