---
layout: code
title: webpackでbabel, coffeescript, css, stylusをコンパイルする
date: 2016-05-10 03:51:37 +0900
tags: [webpack, babel, coffeescript, css, stylus, error]
---


```
npm install webpack -g
npm install -D babel-loader babel-core babel-preset-es2015
npm install -D stylus-loader@1.6.1
```

`webpack`コマンドだけグローバルでインストールします。`babel`は`babel-preset-es2015`と必要なファイルが分割されるようになったらしいので別途インストール。これがないと、`export default`などの記述でエラーが出ます。

プリセットは入れるだけではだめでプロジェクトのルートに`.babelrc`を作り設定しないといけません。`webpack`に書くわけではないので注意。ここで詰まりました。

`babelrc`
```json
{
  "presets": ["es2015"]
}
```

`stylus-loader`は`2.0.0`だと下記のエラーが出ます。[同じ症状がissueで挙げられていました。](https://github.com/shama/stylus-loader/issues/18)`1.6.1`を使えばエラーを回避することができます。

`webpack`と打てば、プロジェクトルートにある`webpack.config.js`が読み込まれます。下記の通りに設定しました。

```javascript
module.exports = {
  entry: {
    app: ["./src/entry.js"]
  },
  output: {
    filename: "build/[name].js"
  },
  devtool: "#source-map",
  moudle: {
    loaders: [
      {test: /\.js$/, loader: "babel", exclude: /node_modules/},
      {test: /\.coffee$/, loader: "coffee"},
      {test: /\.css$/, loader: "style!css"},
      {test: /\.styl$/, loader: "style!css!stylus"}
    ]
  },
  resolve: {
    extensions: ['', '.js', '.jsx', '.coffee', '.css', '.styl']
  }
};
```

cssや画像もモジュールとして`require`できます。cssは`bundle.js`に文字列として書き込んで動的にHTMLに挿入してくれるみたいです。画像も出来るのは驚きました。今回は下記のような`entry.js`を作って試してみました。

```javascript
require('style!css!../styles/style');
require('style!css!stylus!../styles/style.styl');

var Person = require('./person'),
    Food   = require('coffee!./food'),
    Car    = require('babel!./car.js').default;

var mike  = new Person('Mike', 18),
    rice  = new Food('Rice'),
    lapin = new Car('Lapin');

console.log(mike.hello());
console.log(rice.sell(80));
console.log(lapin.move(800));
```
