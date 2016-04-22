---
layout: code
title: 標準入力をStringIOに置き換えてテストする
tags: [ruby]
---

# 標準入出力を`StringIO`に置き換える

helloコマンドは標準入力を表示します。オプション`tmp_option`は特に使われていません。

```ruby
require 'thor'
require_relative '../lib/my_app'

class Command < Thor
  desc 'hello', 'command for test'
  option :tmp_option, :aliases =>'-t', :type => :string
  def hello
    puts($stdin.eof? ? "no pipe" : $stdin.read)
  end
end
```

この標準入力をターミナル上ではなく、テストコードから入力します。全く同じには出来ないのですが、同じような動作をする`StringIO`をモックとして使います。`StringIO`は`String`に`IO`、つまり入出力のメソッドがついたものです。

`puts`などの出力は、`StringIO`をバッファとして溜め込まれます。そしてバッファから内容を出力してテストをするわけです。標準入力はグローバル変数`$stdin`に入っていますので、レシーバに`$stdin`を指定しているなら、これに`StringIO`を直接入れてもいいかもしれません。`StringIO`の詳細な動きは、最後にテストコードを貼っておきます。

`$stdin.eof?`で、標準入力がない場合を判断しています。

```ruby
class HelloTest < Test::Unit::TestCase
  test "hello" do
    $stdin = StringIO.new("hello\nworld\n")
    out = capture_output { Command.start(%w{hello -t hoge}) }[0]
    assert_equal out, "hello\nworld\n"
  end
```

# 標準入出力を切り替えられるようにする

直接`$stdin`に入れると、`$stdin`の影響がどこまであるか考える必要があります。なので、標準入出力を切り替えれるコネクタをインスタンス変数で用意して置くと、より安全になります。もちろん`puts`など自分のコードで使っている同じメソッドがあるオブジェクトを使います。

```ruby
class MyApp
  attr_accessor :input, :output

  def initialize
    self.input = $stdin
    self.output = $stdout
  end

  def say
    output.puts(input.gets.chomp)
  end
end
```

```ruby
require 'thor'
require_relative '../lib/my_app'

class Command < Thor
  desc 'hello', 'command for test'
  option :tmp_option, :aliases =>'-t', :type => :string
  def hello
    puts $stdin.read
  end

  desc 'say', 'command for test'
  option :tmp_option, :aliases =>'-t', :type => :string
  def say
    app = MyApp.new
    app.input = StringIO.new(options['tmp_option'])
    app.say
  end
end
```

```ruby
class HelloTest < Test::Unit::TestCase
  test "hello" do
    $stdin = StringIO.new("hello\nworld\n")
    out = capture_output { Command.start(%w{hello -t hoge}) }[0]
    assert_equal out, "hello\nworld\n"
  end

  test "say" do
    $stdin = StringIO.new("hello")
    out = capture_output { Command.start(%w{hello -t hoge}) }[0]
    assert_equal out, "hello\n"
  end
end
```

# StringIOのテスト

`puts`などの出力を`StringIO`に溜め込み、`read`や`gets`で取り出します。`read`は全てを、`gets`は一行ずつ読み込みます。`gets`を使うと、プロパティ`lineno`が進められます。注意点としては、この2つを使う前に`rewind`を使ってポインタを先頭に戻す必要があります。この場合のポインタとは、内容をどこから読み込むかという目印です。`puts`などで出力していくとポインタは末尾にあるので、それを先頭に戻してから読み込むわけです。

```ruby
require 'test/unit'
class StringIOTEST < Test::Unit::TestCase
  test "standard test" do
    io = StringIO.new
    assert_equal io.lineno, 0
    io.puts('abcd')
    io.puts('efg')
    assert_equal io.lineno, 0

    assert_equal io.read, ''
    assert_true io.eof?
    io.rewind
    assert_false io.eof?
    assert_equal io.lineno, 0
    assert_equal io.read, "abcd\nefg\n"
    assert_equal io.lineno, 0
    assert_equal io.read, ''

    io.rewind
    assert_equal io.gets, "abcd\n"
    assert_equal io.lineno, 1
    assert_equal io.gets, "efg\n"
    assert_equal io.lineno, 2
    assert_nil io.gets
    assert_equal io.lineno, 2

    io.lineno = 0
    assert_equal io.lineno, 0
    assert_nil io.gets
    assert_equal io.lineno, 0
    io.rewind
    assert_equal io.gets, "abcd\n"
    assert_equal io.lineno, 1

    io = StringIO.new("abcdefg")
    assert_equal io.read, 'abcdefg'
  end
end
```
