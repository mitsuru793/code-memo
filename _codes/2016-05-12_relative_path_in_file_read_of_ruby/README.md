---
layout: code
title: Rubyでファイルを読み込む時に、相対パスを指定するとどこを相対とするのか？
date: 2016-05-12 15:53:49 +0900
tags: [ruby]
---

Rubyでファイルを読み込む時に、相対パスを指定するとどこを相対とするのか？実行場所？実行ファイルがある場所？それを調べてみました。

結果は、実行ファイルがある場所でした。

```ruby
# main.rb
puts File.read('./sample.txt')
```

```
❯ tree
.
├── dir1
│   └── sample.txt
├── main.rb
└── sample.txt

1 directory, 4 files
❯ cat sample.txt
root hello world
❯ cat dir1/sample.txt
dir1 hello world

❯ ruby main.rb sample.txt
root hello world
❯ cd dir1
❯ ruby ../main.rb sample.txt
dir1 hello world
```
