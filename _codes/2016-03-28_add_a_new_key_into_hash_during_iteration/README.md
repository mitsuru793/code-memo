---
layout: code
title: Hashのkeyをシンボルから文字列へ変更する
tags: [ruby]
---

`Hash`を`each`で回している時に、レシーバであるハッシュに新しい`key`を追加することはできません。`RuntimeError`が発生し、`can't add a new key into hash during iteration`と表示されます。

そこで先に文字列に変換した`key`の配列を作ります。この`key`の配列を`each`で回して、そのループの中で`Hash`に新しい`key`を追加します。`each`のレシーバは`Hash`ではなく、`key`の配列なのでエラーは起きません。ただ、要素数が2倍になるので古いシンボルのペアは削除します。

```ruby
  hash = {id: 1, name: "Mike"}
  keys = hash.keys.map {|v| v.to_s}
  assert_equal keys, ["id", "name"]

  keys.each do |key|
    hash[key] = hash[key.to_sym]
    hash.delete(key.to_sym)
  end
```

`Array`の場合は、レシーバから値を取り出すことはありますが、レシーバに値を追加することはあまりないと思うので気にする必要はないかもしれません。

```ruby
array1 = [1, 2]
array2 = [3, 4]
array2.each do |val|
  array1.push(val)
end
assert_equal array1, [1, 2, 3, 4]
assert_equal array2, [3, 4]
```
