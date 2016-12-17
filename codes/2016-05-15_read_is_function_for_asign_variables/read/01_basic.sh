#!bin/bash
# https://fumiyas.github.io/2013/12/14/read.sh-advent-calendar.html

read foo <<< 'foo bar'
echo $foo # foo bar

read foo bar <<< 'foo bar'
echo $bar $foo # bar foo

read foo <<< "foo\n"
echo $foo # foon
