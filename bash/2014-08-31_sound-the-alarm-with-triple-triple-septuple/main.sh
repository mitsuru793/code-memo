#!/bin/bash
#1:音を慣らす　2:待機
pettern=(1 1 1 0 1 1 1 0 1 1 1)

for i in ${pettern[@]}
do
  if [ $i -eq 1 ]
  then
    echo -n -e "ド\a "
    sleep 0.5
  else
    echo -n 'ッ '
    sleep 0.5
  fi
done
echo ""
