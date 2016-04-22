---
layout: page
title: ArrayとHashに複数の要素が含まれているかチェックする
---

`Array`と`Hash`を拡張してメソッドを追加します。

* `Array#include?`は、一つの値しか含まれているかチェックできません。なので、`any?`と一緒に使います。
* `Hash#include?`は、1つのkeyが含まれているかの判定です。他のハッシュ、keyとvalueのペアが含まれているかをチェックするメソッドはないので、自作します。

`Hash#include?`が要素ではなく、keyのチェックなので追加メソッド名は、`include_all?`ではなく、`include_all_hash?`にしています。

```
[1, 2, 3].include_any?([1, 0])
# => true

{id: 1, name: "Mike", age: 20}.include_all_hash?(id: 1, name: "Mike")
# => true
```

```ruby
class Array
  def include_all?(other)
    other.all? {|other_value| include?(other_value)}
  end

  def include_any?(other)
    other.any? {|other_value| include?(other_value)}
  end
end

class Hash
  def include_all_hash?(other)
    other.each do |key, val|
      if has_key?(key)
        return false if fetch(key) != val
      else
        return false
      end
    end
    true
  end

  def include_any_hash?(other)
    other.each do |key, val|
      return true if has_key?(key) and fetch(key) == val
    end
    false
  end
end
```
