#!/bin/bash
i=0
for L in `cat data.txt`
do
  i=`expr $i + 1`
  echo $i : $L
done
