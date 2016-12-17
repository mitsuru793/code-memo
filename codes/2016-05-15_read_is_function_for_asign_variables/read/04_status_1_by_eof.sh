#!/bin/bash
# https://fumiyas.github.io/2013/12/14/read.sh-advent-calendar.html

read i1 i2 < /dev/null
echo -E "status=$? i1=[$i1] i2=[$i2]"

read i1 i2 < <(echo -n 'foo')
echo -E "status=$? i1=[$i1] i2=[$i2]"
