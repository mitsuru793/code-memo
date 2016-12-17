#!/bin/bash

echo $FOO
# $をつけたら意味がない $は参照であって変数ではない
# unset $FOO

# スクリプト内のみに有効
unset FOO
echo $FOO
