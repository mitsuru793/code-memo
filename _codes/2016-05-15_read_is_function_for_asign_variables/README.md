---
layout: code
title: bashのreadとは変数に代入するための便利関数
date: 2016-05-15 02:14:58 +0900
tags: [bash]
---

調べて実際に打ち込んだ感じだと、`read`は変数に代入するための機能豊富な関数といった感じ。主に次の3つの動作を把握しておけば、スクリプトを読む上では問題ないと思いました。

# readで覚えておくこと

## 標準入力をデリミタによって各変数に代入

```bash
read foo bar <<< 'foo bar'
echo $bar $foo # bar foo
```

## ユーザーからの入力を受け付ける

```bash
echo 'Do you start? (yes or no)'
read answer
case "$answer" in
  yes)
    : OK
    ;;
  *)
    echo 'interrupt'
    exit 1
    ;;
esac
```

## ヒアドキュメントを読み込む

```bash
cnt=0
while read line
do
  cnt=`expr $cnt + 1`
  echo "LINE $cnt : $line"
done << END
ABC
DEF
GHK
END
# LINE 1 : ABC
# LINE 2 : DEF
# LINE 3 : GHK
```

# 参考

1. [read コマンドの使い方 - 拡張 POSIX シェルスクリプト Advent Calendar 2013 - ダメ出し Blog](https://fumiyas.github.io/2013/12/14/read.sh-advent-calendar.html)
2. [シェルスクリプトでよく使われる while read line 4パターン - eTuts+ Server Tutorial](http://server.etutsplus.com/sh-while-read-line-4pattern/)
3. [シェルスクリプトのデバッグは typeset または declare を使うと良いかも - よんちゅBlog](http://yonchu.hatenablog.com/entry/2013/07/09/230656)
4. [シェルの変数展開 - Qiita](http://qiita.com/bsdhack/items/597eb7daee4a8b3276ba)
5. [環境変数PATHをわかりやすく表示する - Qiita](http://qiita.com/tanaka51/items/840061ea9715fc7602ee)
