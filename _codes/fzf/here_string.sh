#!/bin/bash

str=`cat << EOS
1.hello
2.world
3.foo
4.bar
EOS
`

# ダブルクォートで囲まないと、改行付きにならない。
cat <<< "$str"
