---
layout: code
title: 3回目にマッチした行を置換する
tags: [ruby]
date: 2016-04-22 00:00:00 +0900
---

`String#each_line`は、文字列を改行文字で分割して`Array`を作りループします。これを使い各行を検索して、マッチする度にマッチ回数をインクリメントします。マッチ回数が指定数に達したた時に、行を置換します。

`String#each_line`のブロック文では、`line`を書き換えても元の文字列は書き換わらないので別の文字列に各行を足していきます。

```ruby
class ReplaceLineTest < Test::Unit::TestCase
  def setup
    content = <<-EOF
1. hello
2. world
3. hello
4. world
    EOF
    File.write('hello.txt', content)
  end

  test "replace_nth" do
    buff = File.read('hello.txt')
    three_line = replace_nth(buff, 'hello', 'after', 2).split("\n")[2]
    assert_equal three_line, '3. after'
  end
end

def replace_nth(lines, pattern, replacement, match_number)
  match_count = 0
  new_lines = ''
  lines.each_line do |line|
    match_count += 1 if line.match(pattern)
    line.gsub!(pattern, replacement) if match_count == match_number
    new_lines += line
  end
  new_lines
end
```
