---
layout: code
title: guardでテストを実行するとrequireしたものは引き継がれる
tags: [ruby, guard]
date: 2016-04-25 00:06:07 +0900
---

`guard`で`watch`してテストを実行すると、各ファイルごとに`require`はされません。`require`したものは引き継がれるようです。`include`で同じ問題があったので実験してみました。`guard-test`, `guard-minitest`のどちらも同じ結果でした。完全に切り分けたい場合は、`ruby test/~_test.rb`と個別にファイルを実行するしかないようです。

# guard-test

```ruby
# lib/hello.rb
puts 'hello.rb START'
```

```ruby
# test/hello_test.rb
require 'test/unit'
require_relative '../lib/hello'

class HelloTest < Test::Unit::TestCase
  test "" do
    assert true
  end
end
```

```ruby
# test/hello_2_test.rb
require 'test/unit'
require_relative '../lib/hello'

class Hello2Test < Test::Unit::TestCase
  test "" do
    assert true
  end
end
```

```
❯ bundle exe guard
20:22:47 - INFO - Guard::Test 2.0.8 is running, with Test::Unit 3.1.8!
20:22:47 - INFO - Running all tests
hello.rb START
Started
..

Finished in 0.000758 seconds.
---------------------------------------------------------------------------------------------------------
2 tests, 2 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
100% passed
---------------------------------------------------------------------------------------------------------
2638.52 tests/s, 2638.52 assertions/s
2 tests, 2 asserts, 0 fails, 0 errors

Finished in 0.0008 seconds

20:22:47 - INFO - Guard is now watching at '/Users/mitsuru/code/myrepository/code-memo/_codes/ruby_sample/guard-test'
[1] guard(main)>
```

# guard-minitest

```ruby
# lib/hello.rb
puts 'hello.rb START'
```

```ruby
# test/hello_test.rb
require 'minitest/autorun'
require_relative '../lib/hello'

class HelloTest < Minitest::Test
  def test_hello
    assert true
  end
end
```

```ruby
# test/hello_2_test.rb
require 'minitest/autorun'
require_relative '../lib/hello'

class Hello2Test < MiniTest::Test
  def test_hello
    assert true
  end
end
```

```
❯ be guard
23:59:22 - INFO - Guard::Minitest 2.4.4 is running, with Minitest::Unit 5.8.4!
23:59:22 - INFO - Running: all tests
hello.rb START
Run options: --seed 34659

# Running:

..

Finished in 0.001223s, 1635.4474 runs/s, 1635.4474 assertions/s.

2 runs, 2 assertions, 0 failures, 0 errors, 0 skips

23:59:23 - INFO - Guard is now watching at '/Users/mitsuru/code/myrepository/code-memo/_codes/ruby_sample/guard-minitest'
[1] guard(main)>

```
