#!/bin/bash

echo $FOO
FOO=AFTER_FOO
# $をつけてもいい
#export $FOO
export FOO
echo $FOO
# スクリプト内のみ変更が有効
