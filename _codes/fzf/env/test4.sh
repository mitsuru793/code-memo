#!/bin/bash

# sourceで実行すると環境変数FOOを書き換えて、削除する。
hoge() {
  echo $FOO
  FOO='after'
  unset FOO
}
hoge
