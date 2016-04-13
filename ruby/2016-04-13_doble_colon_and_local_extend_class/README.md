---
layout: page
title: 「ダブルコロンでのトップレベルの参照」と「局所的なクラス拡張」
---

# モジュール内でクラス拡張はできない

```ruby
class String
  def root_hello
    "root hello"
  end
end

module RootModule
  class String
    def root_module_hello
      "root module hello"
    end
  end
end
```

モジュール内で`"".root_module_hello`と使っても`NoMethodError`となります。これは`""`を使うと、拡張されていないトップレベルの`String`が生成されます。`String.new.root_module_hello`とすばれ、拡張したメソッドを使うことができます。モジュール内で`String`とクラス名を直接書いた場合は、モジュール内の`String`が参照されます。

トップレベルの`String`は文字列を生成するクラスですが、モジュール内で定義した`String`はただの名前が同じの別クラスです。クラス拡張しているわけでもなく、この2つの`String`は全く関係がありません。だから、モジュールの外から`"".root_module_hello`は使えません。モジュールはクラス拡張を局所的にすることができます。

# クラス拡張したならコンストラクタは正常だ

下記のコードは上は同じ名前の`String`を定義しているだけです。`initialize`を定義していないので、`ArgumentError`が起きています。下は親クラスを指定して継承して、`initialize`も受け継がれています。これは既存クラスを拡張しているわけではないので、トップレベルの`String`とは別物です。

```ruby
module Module1
  class String; end

  def self.create_instance
    String.new "test" # ArgumentError
  end
end

module Module2
  class String < ::String
  end

  def self.create_instance
    String.new "test"
  end

  def self.compare_string?
    String.equal?(::String) # false
  end
end
```

# ダブロコロンを使った型判定

次はダブルコロンあり、なしでの型判定について見ていきます。

```ruby
module NoExtend
  def self.compare_string?
    String === ::String # false
  end

  def self.compare_string2?
    String === "" # true
  end

  def self.compare_string3?
    ::String === "" # true
  end
end

module Extend
  class String; end

  def self.compare_string?
    String === ::String # false
  end

  def self.compare_string2?
    String === "" # false
  end

  def self.compare_string3?
    ::String === "" #true
  end
end
```

`NoExtend`も`Extend`でも、`String === ::String`はfalseを返します。 `mod === obj`は、 `is_a?`/`kind_of?`と同じです。オブジェクト`obj`が`mod`クラスのインスタンスかを調べます。`::String`は`String`のインスタンスではなくクラスです。だから`false`が返ります。**モジュール内でクラス拡張した際は、型判定にはコロンをつけてトップレベルのクラスを使うようにした方がいいかもしれません。**

2つのモジュールの違いは、`String === ""`の返り値です。これは前述した内容と同じです。別の`String`を定義したせいで、`Extend`の中の`String`はトップレベルのを参照しません。別の`String`になっていることを次のコードで確認してみましょう。`String.equal?(::String)`の部分です。

# クラス拡張をすると、モジュールの名前空間に新しいクラスが登録される

```ruby
module NoExtend
  def self.equal_string?
    String.equal?(::String) # true
  end

  def self.equal_string2?
    String.equal?("") # false
  end

  def self.equal_string3?
    ::String.equal?("") # false
  end
end

module Extend
  class String; end

  def self.equal_string?
    String.equal?(::String) # false
  end

  def self.equal_string2?
    String.equal?("") # false
  end

  def self.equal_string3?
    ::String.equal?("") # false
  end
end
```

`equal?`は`==`の別名です。同じオブジェクトかを判断しています。`NoExtend`の方では`true`のままです。クラス拡張を行わない場合は、`String`のままでトップレベルのを参照できています。`String.equal?("")`と`::String.equal?("")`はクラスとインスタンスが同じかを比較しているので、クラス拡張や名前空間は関係なしに`false`になります。

# クラス拡張を局所的にするにはどうするか？

モジュール内で継承クラスを作るか、`refine`と`using`を使います。

```ruby
module NormalUsingModule
  refine String do
    def normal_using_hello
      "normal using hello"
    end
  end
end

using NormalUsingModule
```

上記の`using`以降から`"".normal_using_hello`が使えます。このファイルを`require`した場合は、再度`using`を記述しないといけません。`using`のスコープはファイル内に留められています。

さて、どちらの方法を使えばいいのか？自作のライブラリでしか使わないなら直接クラス拡張を、クラス拡張自体を色々な場所で使いまわしたいなら`using`を使うといいと思います。ただ、前者でも自作ライブラリの中で全体ではなく、さらに一部だけに影響を絞りたいなら`using`を使うといいでしょう。
