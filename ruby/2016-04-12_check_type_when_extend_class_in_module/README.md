---
layout: page
title: モジュール内でクラス拡張した際の型判定
---

モジュール内で拡張したクラスのインスタンスかどうかをチェックするには、クラス名の先頭にダブルコロンをつけます。 モジュール内で配列を生成する場合は、`Array.new`だとモジュール内の`Array`が、`[]`だとトップレベルの`Aray`が生成されます。

注意点は、モジュール内でシンタックスシュガーであるブラケットを使うと、トップレベルの`Array`が生成されることです。この場合に型をチェックする際は`::Array`を使いましょう。モジュール内でクラス拡張をした場合も同じくです。


```ruby
class Array; end

module MyModule
  class Array; end

  def self.get_array
    []
  end

  def self.is_inside_array?
    # モジュール内で拡張したArrayと比較
    [].is_a?(Array) # false
  end

  def self.is_top_array?
    # モジュールの外側で定義したArrayと比較
    [].is_a?(::Array) # true
  end

  def self.is_new_array?
    Array.new.is_a?(Array) # true
  end

  def self.is_new_top_array?
    ::Array.new.is_a?(Array) # false
  end
end
```
