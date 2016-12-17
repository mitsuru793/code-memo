#!/bin/bash
# https://fumiyas.github.io/2013/12/14/read.sh-advent-calendar.html

i1=xxx
i2=yyy
read i1 i2 <<< ''
echo -E "status=$? i1=[$i1] i2=[$i2]"
# status=0 i1=[] i2=[]

i1=xxx
i2=yyy
read i1 i2 <<< 'foo'
echo -E "status=$? i1=[$i1] i2=[$i2]"
# status=0 i1=[foo] i2=[]
