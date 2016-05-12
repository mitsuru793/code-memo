---
layout: code
title: refineを使ったクラス拡張を実行コマンドでも使えるようにする
tags: [ruby]
date: 2016-04-15 00:00:00 +0900
---

`refine`を使ったクラス拡張を、実行コマンドでも使えるようにします。次のような出力をするコマンドです。

```
> bin/main hello
String Hello
Array Hello
```
# パターン1

クラス拡張の影響を受けるファイルには、都度`using`を記述する必要があります。

```ruby
#!/usr/bin/env ruby
# bin/main
require 'thor'
require_relative '../lib/my_module'

class Command < Thor
  using MyModule
  desc "hello", "test method"
  def hello
    puts "".hello
    puts [].hello
  end
end

Command.start(ARGV)
```

外部ファイルの読み込みは`require`にすると、エラーになります。`require_relative`を使いましょう。

```ruby
# lib/my_module.rb
require_relative 'array'
require_relative 'string'
```

```ruby
module MyModule
  refine Array do
    def hello
      "Array Hello"
    end
  end
end
```

```ruby
module MyModule
  refine String do
    def hello
      "String Hello"
    end
  end
end
```

# パターン2

`using MyModue`を削除してしまうと、`puts MyModule.get_empty_string.hello`でエラーが起きます。

```ruby
#!/usr/bin/env ruby
require 'thor'
require_relative '../lib/my_module'

class Command < Thor
  using MyModule
  desc "hello", "test method"
  def hello
    puts MyModule.string_hello
    puts MyModule.get_empty_string.hello
  end
end

Command.start(ARGV)
```

```ruby
require_relative 'array'
require_relative 'string'

module MyModule
  using MyModule
  def self.string_hello
    String.new("").hello
  end

  def self.get_empty_string
    String.new("")
  end
end
```
