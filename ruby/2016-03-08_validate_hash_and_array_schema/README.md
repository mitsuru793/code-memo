---
layout: page
title: ArrayとHashのスキーマをチェックする
---
`Array`や`Hash`のスキーマをチェックする方法です。各要素の型をチェックすることができます。スキーマ自体は、`Array`や`Hash`で定義することができます。

既存の`Array`クラスと`Hash`クラスに`has_shape?`を追加して実現しています。各要素のチェックには、[Enumerable#all?](http://ref.xaio.jp/ruby/classes/enumerable/all)を使っています。

```ruby
# 変数shapeがスキーマです。
shape = { id: Integer, name: String }
p { id: 1, name: "Mike"}.has_shape?(shape)
# => true

p { id: 1, first_name: "Mike"}.has_shape?(shape)
# => false

p { id: 1, name: 00}.has_shape?(shape)
# => false

shape = {
  id: Integer,
  items: { name: String, price: Integer }
}
hash = {
  id: 1,
  items: { name: "ball", price: 1000 }
}
p hash.has_shape?(shape)
# => true

shape = {
  id: [Integer, Integer, Integer]
}
p {id: [1, 2, 3]}.has_shape?(shape)
# => true
```

### 参考
* [mongodb - Validating the shape of Ruby hashes? - Stack Overflow](http://stackoverflow.com/questions/11106805/validating-the-shape-of-ruby-hashes)
