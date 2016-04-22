---
layout: code
title: クラス拡張を特定のクラス・インスタンスのみで行う
tags: [ruby]
---

`refine`を使えば特定のクラス内のみに、クラス拡張の影響を限定することができます。

```ruby
module ExtendArray
  refine Array do
    def hello
      "extend array hello"
    end
  end
end

class ArrayB
  using ExtendArray
  VAL = [3, 4]
  def self.instance_hello
    VAL.hello
  end

  def self.get_array
    [5, 6]
  end
end
```
`ArrayB`の中でusingを使っているので、`ArrayB`の定義内でなら`ExtendArray`モジュールで拡張したメソッドが使うことが出来ます。外部から`ArrayB.get_array`で配列を取得した後に拡張メソッドを使おうとしても、`NoMethodError`となります。

特定の生成したオブジェクトのみに拡張を絞りたい場合はextendメソッドを使います。これで`get_hash`の戻り値のみに拡張を留めることができます。

```ruby
module ExtendHello
  def hello
    "ExtendHello hello"
  end
end

module ExtendSay
  def say
    "ExtendSay say"
  end
end

class MyHash
  def self.get_hash
    {}.extend(ExtendHello, ExtendSay)
  end
end
```
