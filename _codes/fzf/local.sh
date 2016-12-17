#!/bin/bash

function hello() {
  my_val="hello"
}

hello
echo $my_val # hello

function hello2() {
  local my_val2="hello2"
}

hello2
echo $my_val2 # 空出力
