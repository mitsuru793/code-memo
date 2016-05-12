---
layout: code
title: クラスやメソッドの色々な定義方法
tags: [ruby]
date: 2016-05-01 00:00:00 +0900
---

```ruby
class Foo
  def self.class_method1
  end

  class << Foo
    def self.class_method2
    end
  end

  class << self
    def self.class_method3
    end
  end

  def instance_method
  end
end

foo = Foo.new
def foo.object_method1
end

class << foo
  def object_method2
  end
end

class << Foo
  def class_method4
  end
end
```

```ruby
Foo = Class.new do
  def instance_method
  end
end

def Foo.class_method
end
```
