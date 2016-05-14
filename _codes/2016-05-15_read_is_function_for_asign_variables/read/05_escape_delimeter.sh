#!/bin/bash
# https://fumiyas.github.io/2013/12/14/read.sh-advent-calendar.html

read i1 i2 < <(echo 'foo\ bar')
echo -E "status=$? i1=[$i1] i2=[$i2]"
# status=0 i1=[foo bar] i2=[]

read i1 i2 < <(echo -E 'foo\   bar\n')
echo -E "status=$? i1=[$i1] i2=[$i2]"
# status=0 i1=[foo ] i2=[barn]

read i1 i2 < <(echo -E 'foo \   bar')
echo -E "status=$? i1=[$i1] i2=[$i2]"
# status=0 i1=[foo] i2=[   bar]

read i1 i2 < <(echo -E 'foo bar\'; echo -E 'baz')
echo -E "status=$? i1=[$i1] i2=[$i2]"
# status=0 i1=[foo] i2=[barbaz]
