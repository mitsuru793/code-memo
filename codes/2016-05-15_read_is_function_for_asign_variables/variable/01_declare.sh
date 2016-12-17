#!/bin/bash
# http://qiita.com/toshiro3/items/647d7fc4a1d4e3232b66

declare -i num=1+2
str=1+2

echo $num # 3
echo $str # 1+2

declare -a array=( Java Ruby Python)
echo ${array[0]} # Java
echo ${array[@]} # Java Ruby Python
echo ${#array[@]} # Java Ruby Python

for e in ${array[*]}
do
  echo $e
done
# Java
# Ruby
# Python

for i in ${!array[*]}
do
  echo "$i:${array[i]}"
done
# 0:Java
# 1:Ruby
# 2:Python

declare -A hash=([Jack]=11 [Queen]=12 [King]=13)
echo ${hash['King']} # 13

for v in ${hash[*]}
do
  echo $v
done
# 11
# 13
# 12

for k in ${!hash[*]}
do
  echo "$k:${hash[$k]}"
done
# Jack:11
# King:13
# Queen:12

declare -r ro_var='readonly variable'
echo $ro_var # readonly variable
# ro_var='writable?' # ro_var: readonly variable

declare -x env_var='environment variables'
export -p | grep env_var # declare -x env_var="environment variables"

export -p | grep TZ #
date # 2016年 5月14日 土曜日 20時08分07秒 JST

declare -x TZ='UTC'
export -p | grep TZ # declare -x TZ="UTC"
date # 2016年 5月14日 土曜日 11時08分07秒 UTC

var='Hello, World!'
declare -p num   # declare -i num="3"
declare -p array # declare -a array='([0]="Java" [1]="Ruby" [2]="Python")'
declare -p hash  # declare -a hash='([0]="13")'
declare -p var   # declare -- var="Hello, World!"

declare -u upper_var='hello, world!'
echo $upper_var
# HELLO, WORLD!

declare -l upper_var='HELLO, WORLD!'
echo $upper_var
# hello, world!
