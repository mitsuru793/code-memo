#!/bin/bash
# https://fumiyas.github.io/2013/12/14/read.sh-advent-calendar.html

echo 'Do you start? (yes or no)'
read answer
case "$answer" in
  yes)
    : OK
    ;;
  *)
    echo 'interrupt'
    exit 1
    ;;
esac

echo 'finish script'
exit 0
