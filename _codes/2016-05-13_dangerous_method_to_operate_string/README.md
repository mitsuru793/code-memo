---
layout: code
title: 文字列を加工する破壊的メソッドを作る
date: 2016-05-13 01:03:16 +0900
tags: [ruby]
---

文字列を加工する関数を作りたいのですが、戻り値を返して代入する必要があります。それをなくすために自分で破壊的メソッドを作ってみます。

```ruby
def add_string(content)
  content += "last\n"
end

def modify_first_line(content)
  content.each_line do |line|
    line = "after line"
    break
  end
end
```

上記だと呼び出し元のオブジェクトに変化はありません。破壊的メソッドにするには`replace`メソッドを使います。

```ruby
def add_string!(content)
  new_content = content + "last\n"
  content.replace(new_content)
end

def modify_first_line!(content)
  new_content = []
  content.each_line.with_index(0) do |line, i|
    line = "after line\n" if i == 0
    new_content << line
  end
  content.replace(new_content.join)
end
```

これで破壊的メソッドになりました。
