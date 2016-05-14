#!/bin/bash

# http://qiita.com/mattintosh4/items/a98cfb5a62ee95c8a137
old_IFS=$IFS


read v1 v2 v3 <<< "1 2 3"
declare -p ${!v*}
# declare -- v1="1"
# declare -- v2="2"
# declare -- v3="3"

IFS=,
read v1 v2 v3 <<< "1 2 3"
declare -p ${!v*}
# declare -- v1="1 2 3"
# declare -- v2=""
# declare -- v3=""

IFS=$old_IFS
while read -n 1 c
do
  declare -p c
done << EOS
abc
def
EOS
# declare -- c="a"
# declare -- c="b"
# declare -- c="c"
# declare -- c=""
# declare -- c="d"
# declare -- c="e"
# declare -- c="f"
# declare -- c=""

while read -n 1 c
do
  # 改行文字は空扱い
  [ "$c" ] && declare -p c
done << EOS
abc
def
EOS
# declare -- c="a"
# declare -- c="b"
# declare -- c="c"
# declare -- c="d"
# declare -- c="e"
# declare -- c="f"

IFS=,
read -a array <<< '1 2 3'
declare -p array
# declare -a array='([0]="1 2 3")'

read -a array <<< '1,2,3'
declare -p array
# declare -a array='([0]="1" [1]="2" [2]="3")'

while read -a array
do
  printf -- "------------------------
国名: %s
番号: %s
スペーステスト: %s
エスケープテスト %s
------------------------\n" "${array[@]}"
done << EOS
アメリカ,1,1 2 3,\,\,\,
イギリス,44,1 2 3,\,\,\,
日本,81,1 2 3,\,\,\,
EOS
# ------------------------
# 国名: アメリカ
# 番号: 1
# スペーステスト: 1 2 3
# エスケープテスト ,,,
# ------------------------
# ------------------------
# 国名: イギリス
# 番号: 44
# スペーステスト: 1 2 3
# エスケープテスト ,,,
# ------------------------
# ------------------------
# 国名: 日本
# 番号: 81
# スペーステスト: 1 2 3
# エスケープテスト ,,,
# ------------------------

IFS=' ,.'
read v1 v2 v3 v4 <<< '1 2,3.4'
declare -p ${!v*}
# declare -- v1="1"
# declare -- v2="2"
# declare -- v3="3"
# declare -- v4="4"

IFS=$old_IFS
declare -p REPLY # 09.sh: 101 行: declare: REPLY: 見つかりません
read <<< foo
declare -p REPLY # declare -- REPLY="foo"

while read
do
  echo $REPLY
done << EOS
no.1
no.2
no.3
EOS
# no 1
# no 2
# no 3

i=0
while read
do
  printf "%2d: $REPLY\n" $((i++))
  while read
  do
    printf "%2d: $REPLY\n" $((i++))
  done << EOS2; done << EOS1 # doneを2行に分けてはダメ
[子] 1行目
[子] 2行目
[子] 3行目
EOS2
[親] 1行目
[親] 2行目
[親] 3行目
EOS1
# 0: [親] 1行目
# 1: [子] 1行目
# 2: [子] 2行目
# 3: [子] 3行目
# 4: [親] 2行目
# 5: [子] 1行目
# 6: [子] 2行目
# 7: [子] 3行目
# 8: [親] 3行目
# 9: [子] 1行目
# 10: [子] 2行目
# 11: [子] 3行目


i=0
while read
do
  printf "%2d: $REPLY\n" $((i++))
  while read
  do
    printf "%2d: $REPLY\n" $((i++))
  done << EOS
子
EOS
  declare -p REPLY
done << EOS
親
EOS
# 0: 親
# 1: 子
# declare -- REPLY=""

i=0
echo "親" | while read
do
  printf "%2d: $REPLY\n" $((i++))

  echo "子" | while read
  do
    printf "%2d: $REPLY\n" $((i++))
  done

  declare -p REPLY
done
# 0: 親
# 1: 子
# declare -- REPLY="親"

i=0
cat << EOS | while read
親
EOS
do
  printf "%2d: $REPLY\n" $((i++))

  cat << EOS | while read
子
EOS
  do
    printf "%2d: $REPLY\n" $((i++))
  done

  declare -p REPLY
done
# 0: 親
# 1: 子
# declare -- REPLY="親"

# faleがないと無限ループする
while read && echo $? || { echo $?; false; }
do
  declare -p REPLY
done << EOS
no1
no2
EOS
declare -p REPLY
# 0
# declare -- REPLY="no1"
# 0
# declare -- REPLY="no2"
# 1
# declare -- REPLY=""

printf '@' | read
echo $?
declare -p REPLY
# 1
# declare -- REPLY=""

printf '@' | (read; echo $?; declare -p REPLY)
# 1
# declare -- REPLY="@"

printf '@' | (read -d @; echo $?; declare -p REPLY)
# 0
# declare -- REPLY=""

# > パイプで繋いだ場合、子の read が上書きするのは子の REPLY なので親の REPLY には影響しない。
# > ヒアドキュメントの場合は親と子で共通の REPLY を使っているので子のループが終わる時に REPLY="" になる。

while read && echo $? || { echo $?; false; }
do
  echo "test"
done << EOS
no1
no2
EOS
# 0
# test
# 0
# test
# 1
