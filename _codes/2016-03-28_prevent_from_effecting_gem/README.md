---
layout: code
title: 依存gemの拡張を開発中のgem内に留める
tags: [ruby]
date: 2016-03-28 00:00:00 +0900
---
`module`内でクラス拡張しても、そのファイルを`require`するとクラス拡張はモジュール外にまで影響してしまう。`module`内で`refine`を使えば問題ありません。`refine`を使った`module`を、自作クラスの中で`using`で読みこめば、クラス拡張を自作クラス内に閉じ込めることができます。

```ruby
module ExtendArray
  refine Array do
    def hello
      "Array hello"
    end
  end
end

class HasArray
  using ExtendArray
  def hello_with_array(array)
    array.hello
  end
end
```

クラスではなく、オブジェクトにメソッドを追加するには`extend`を使います。これなら`gem`からオブジェクトを生成するゲッターの中で、そのオブジェクトだけに拡張を留めることができます。依存している`gem`の拡張を、今の`gem`の利用ユーザーにまで影響させたくない場合は、この方法がいいかもしれません。

```ruby
module ExtendArray
  def say
    "ExtendArray module say"
  end
end

class HasArray
  def get_extend_array
    [5,6].extend(ExtendArray)
  end
end
```
