---
layout: code
title: モジュールに定義したクラス変数を後から変更する
date: 2016-05-04 20:11:59 +0900
tags: [ruby]
---

モジュールに定義したクラス変数を後から変更するには、モジュール内に定義したアクセサを使わないといけません。`include`, `extend`したクラスに定義したアクセサを通じても、モジュールにある共通したクラス変数を変更することはできません。

※ テストコードは`bundle exe guard`ではなく、`ruby test/~.rb`と別々に実行しないとエラーになります。これは`guard`が各テストクラスごとに環境をリセットしないためです。クラス変数の変更が引き継がれてしまいます。

```ruby
module Hello
  @@cls_val = "cls val"

  def cls_val_module
    @@cls_val
  end

  def cls_val_module=(val)
    @@cls_val = val
  end
end

class Foo
# include Hello
  extend Hello

  def self.cls_val=(val)
    @@cls_val = val
  end

  def self.cls_val
    @@cls_val
  end
end
```

```ruby
test "can't change cls val module" do
  FooExtend.cls_val = "after"
  assert_equal "after", FooExtend.cls_val
  assert_equal "cls val", FooExtend.cls_val_module
end

test "change cls val module" do
  FooExtend.cls_val_module = "after"
  assert_equal "after", FooExtend.cls_val_module
end
```
