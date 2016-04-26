---
layout: code
title: Module内でクラスインスタンス変数
tags: [ruby]
date: 2016-04-26 18:50:44 +0900
---

# Module内でattr_readerを使う

```ruby
module Attr
  @cls_ins_val = "default cls_ins_val"
  @@cls_val    = "default cls_val"

  attr_reader :cls_ins_val, :cls_val

  class << self
    def get_cls_ins_val
      @cls_ins_val
    end

    def set_cls_ins_val(val)
      @cls_ins_val = val
    end

    def get_cls_val
      @@cls_val
    end

    def set_cls_val(val)
      @@cls_val = val
    end
  end
end
```

自分で定義したゲッターもセッターも問題ありません。デフォルト値の取得も出来ています。

```ruby
test "class instance value" do
  assert_equal "default cls_ins_val", Attr.get_cls_ins_val
  Attr.set_cls_ins_val("after cls_ins_val")
  assert_equal "after cls_ins_val", Attr.get_cls_ins_val

  assert_raise NoMethodError do Attr.cls_ins_val end
end

test "class value" do
  assert_equal "default cls_val", Attr.get_cls_val
  Attr.set_cls_val("after cls_val")
  assert_equal "after cls_val", Attr.get_cls_val

  assert_raise NoMethodError do Attr.cls_val end
end
```

しかし、`attr_reader :cls_ins_val, :cls_val`の部分がうまく機能していません。

```ruby
assert_raise NoMethodError do Attr.cls_ins_val end
assert_raise NoMethodError do Attr.cls_val end
```

# attr_accessorではクラス変数は参照できない

クラスメソッドとして定義するには、下記のように書きます。

```ruby
module Attr2
  @cls_ins_val = "default cls_ins_val"
  @@cls_val    = "default cls_val"

  class << self
    attr_accessor :cls_ins_val, :cls_val
  end
end
```

この場合だと、クラス変数のデフォルト値は`nil`になっています。`attr_accessor`では、クラス変数を受け取る事ができていません。

```ruby
test "class instance value" do
  assert_equal "default cls_ins_val", Attr2.cls_ins_val
  Attr2.cls_ins_val = "after cls_ins_val"
  assert_equal "after cls_ins_val", Attr2.cls_ins_val
  assert_equal "after cls_ins_val", Attr2.cls_ins_val
end

test "class value" do
  assert_nil Attr2.cls_val # "default cls_val"ではない
  Attr2.cls_val = "after cls_val"
  assert_equal "after cls_val", Attr2.cls_val
  assert_equal "after cls_val", Attr2.cls_val
end
```

同じ名前のクラス変数と、クラスインスタンス変数で確かめてみます。

```ruby
module Attr3
  @cls_val     = "default @cls_val"
  @@cls_val    = "default @@cls_val"

  class << self
    attr_accessor :cls_val
  end
end
```

```ruby
assert_equal     "default @cls_val",  Attr3.cls_val
assert_not_equal "default @@cls_val", Attr3.cls_val
```

クラスインスタンス変数の方が参照されていますね。これは、クラスに`attr_accessor`を使った時と同じで下記のように書かれていると推測できます。

```ruby
module Attr3
  @cls_val = "default @cls_val"

  class << self
    def cls_val
      @cls_val
    end

    def cls_val=(val)
      @cls_val = val
    end
  end
end
```

ゲッターの中で`cls_val`の前に付いている`@`は2つではなく、1つです。なのでインスタンス変数を返そうとします。ですが、クラスメソッドですのでレシーバーは`Attr3`クラスです。なのでインスタンス変数ではなく、クラスインスタンス変数が返ります。

# クラス内でincludeする

クラス内で`include`した場合はどうなるか見てみましょう。

```ruby
module Attr2
  @cls_ins_val = "default cls_ins_val"
  @@cls_val    = "default cls_val"

  class << self
    attr_accessor :cls_ins_val, :cls_val
  end
end

class Include2
  include Attr2
end
```

アクセサは`NoMethodError`になります。

```ruby
test "class value" do
  obj = Include2.new
  assert_raise NoMethodError do obj.cls_ins_val end
  assert_raise NoMethodError do obj.cls_val end

  assert_raise NoMethodError do Include2.cls_ins_val end
  assert_raise NoMethodError do Include2.cls_val end
end
```

下記のように`attr_accessor`をクラスメソッドとして書かなくても同じです。自分で定義した`get_cls_ins_val`なども、クラスからでもインスタンスからでも`NoMethodError`になります。

```ruby
module Attr
  @cls_ins_val = "default cls_ins_val"
  @@cls_val    = "default cls_val"

  attr_reader :cls_ins_val, :cls_val

  class << self
    def get_cls_ins_val
      @cls_ins_val
    end

    def set_cls_ins_val(val)
      @cls_ins_val = val
    end

    def get_cls_val
      @@cls_val
    end

    def set_cls_val(val)
      @@cls_val = val
    end
  end
end

class Include
  include Attr
end
```

# moduleをincludeしてインスタンスメソッドを生成

クラスに`include`した時にインスタンスメソッドとしたい場合は、モジュールメソッドに`self`を付けないでおきます。`self`を付けないのは、クラスに直接インスタンスメソッドを定義する時と同じですね。クラスメソッドにした時の挙動が違うのです。

```ruby
module Attr5
  @cls_ins_val = "default cls_ins_val"
  @@cls_val    = "default cls_val"

  def get_cls_ins_val
    @cls_ins_val
  end

  def set_cls_ins_val(val)
    @cls_ins_val = val
  end

  def get_cls_val
    @@cls_val
  end

  def set_cls_val(val)
    @@cls_val = val
  end
end

class Include5
  include Attr5
end
```

クラスインスタンス変数のデフォルト値が取得できていないですね。これはレシーバーがインスタンスだからです。クラスメソッドならレシーバーがクラスなので、クラスインスタンス変数を参照できます。

```ruby
obj = Include5.new

assert_nil obj.get_cls_ins_val
obj.set_cls_ins_val("after cls_ins_val")
assert_equal "after cls_ins_val", obj.get_cls_ins_val

assert_equal "default cls_val", obj.get_cls_val
obj.set_cls_val("after cls_val")
assert_equal "after cls_val", obj.get_cls_val
```
