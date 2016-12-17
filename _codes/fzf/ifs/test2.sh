#!/bin/bash
IFS_BACKUP=$IFS
IFS=$'\n'
i=0
for L in `cat data.txt`
do
  i=`expr $i + 1`
  echo $i : $L
done
IFS=$IFS_BACKUP
