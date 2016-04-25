---
layout: code
title: クラス変数とクラスインスタンス変数の違い
tags: [ruby]
date: 2016-04-25 10:58:50 +0900
---

# selfがインスタンスになる時

`self`は`@`とも書けます。`initialize`の中での`self`はインスタンスです。

```ruby
class Person
  attr_reader :name, :age

  def initialize
    @name = 'Yamada'
    age = 20
    @from = 'Japan'
    home = 'Aichi'

    p self # #<Person:0x007f867a0596e8 @name="Yamada", @from="Japan">
    p self.name  # "Yamada"
    p self.age   # nil
    #p self.from # NoMethodError
    #p self.home  # NoMethodError
  end
end
```

```ruby
class PersonTest < Test::Unit::TestCase
  test "initialize" do
    person = Person.new
    assert_equal person.name, 'Yamada'
    assert_nil person.age
    assert_raise NoMethodError do person.from end
    assert_raise NoMethodError do person.home end
  end
end
```

`self.val=`を定義していないと、`initialize`の中でもインスタンス変数に代入が出来ません。下記だと、`name`のゲッターは`attr_writer`で定義されています。

```ruby
class Person2
  attr_writer :name
  attr_reader :age

  def initialize
    self.name = 'Yamada'
    self.age  = 20 # NoMethodError
  end
end
```
# クラス変数とクラスインスタンス変数の違い

メソッド定義の外、クラス定義内での`self`はそのクラス自身になります。ただし、`@`の数が1つか2つで、クラスインスタンス変数、クラス変数に変わります。`@@cls_val`はクラス変数で、クラス、全インスタンスで共有されます。

```ruby
class Person3
  @cls_ins_val = "default cls_ins_val"
  @@cls_val    = "default cls_val"
  attr_reader :cls_ins_val, :cls_val

  def initialize
    @cls_ins_val = 'change cls_ins_val'
    @@cls_val    = 'change cls_val'
  end

  def self.cls_ins_val
    @cls_ins_val
  end

  def self.cls_val
    @@cls_val
  end
end
```

クラスインスタンス変数である`@cls_ins_val`は、インスタンスメソッドから参照できません。インスタンスメソッド内での`self`, `@`はインスタンスです。これらが指す変数は、インスタンス変数なのでこちらが優先されてしまいます。

`person.cls_ins_val`を見ると、値が変わっているのを確認できますが、その後に`Person3.cls_ins_val`を見ると、値が元に戻っています。これは同じ変数名だけど、クラスインスタンス変数とインスタンス変数であり別物です。

クラスインスタンス変数は継承クラスには引き継がれません。定義クラス内でのみしか使えない変数です。クラス変数をインスタンスメソッドから参照させないようにしたい場合は、クラスインスタンス変数を使うと良いでしょう。こちらはスコープの制限を強めたクラスオブジェクトの変数です。

```ruby
class Person3Test < Test::Unit::TestCase
  test "initialize" do
    person = Person3.new
    assert_equal person.cls_ins_val,  'change cls_ins_val'
    assert_equal Person3.cls_ins_val, 'default cls_ins_val'

    assert_nil   person.cls_val
    assert_equal Person3.cls_val, 'change cls_val'
  end

  test "sub class" do
    class Sub < Person3; end
    sub = Sub.new

    assert_equal sub.cls_ins_val,  'change cls_ins_val'
    assert_nil Sub.cls_ins_val

    assert_nil   sub.cls_val
    assert_equal Sub.cls_val, 'change cls_val'
  end
end
```
