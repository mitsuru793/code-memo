---
layout: code
title: ファイルの最終更新日時を月日時秒で取得
tags: [bash]
---

# 必要なコマンドの確認

## ls
lsのファイルの更新日時を全て出すには、linuxでは--full-time-optionを、macではlと一緒にTオプションを使います。

```bash
if [ "$(uname)" == 'Darwin' ]; then
  # Macの場合実行されます。
  ls -lT $FILE
  # => -rw-r--r--  1 mitsuru  staff  0  1 25 13:39:48 2016 sample_file
elif [ "$(uname)" == 'Linux' ]; then
  # Linuxの場合実行されます。
  ls --full-time
  # => -rw-r--r--. 1 vagrant vagrant 0 2016-01-25 13:51:10.706982847 +0900 sample
fi
```

## awk

awkは1行をタブやスペースで区切り、$1, $2として扱うことができます。行数分だけ実行が繰り返されます。

```bash
cat << EOF | awk '{print $2"-"$1}'
1 2
3 4
EOF
# => 2-1
#    4-3
```

# 本編

```bash
# 出力を確認するのに使うファイル
FILE="sample_file"
touch $FILE

# 通常のワンライナー
ls -lT $FILE | awk '{print $6"-"$7"-"$8}'
# => 1-25-13:35:33
# 以降も上記と同じ出力になるため省略します。

# コマンドを変数に入れて実行
# evalを使わないと、パイプから全てがlsの引数と見なされてしまいます。
# awkの$6, $7, $8の$と、"はエスケープしないといけません。
cmd="ls -lT $FILE | awk '{print \$6\"-\"\$7\"-\"\$8}'"
eval $cmd

# 関数にして実行
function get_time () {
  local target_file=$1
  ls -lT $target_file | awk '{print $6"-"$7"-"$8}'
}
get_time $FILE

# bashでは、戻り値は1~255の数値しか受けつけないので、
# 関数の実行結果を引数に入れるためにバッククオートを使います。
file_time=`get_time $FILE`
echo $file_time

# 戻り値を明示的にするために、returnの代わりにechoを使うといいかもしれません。
function get_time2 () {
  local target_file=$1
  local file_updated_time=`ls -lT $target_file | awk '{print $6"-"$7"-"$8}'`
  echo $file_updated_time
}
file_time=`get_time2 $FILE`
echo $file_time
```
