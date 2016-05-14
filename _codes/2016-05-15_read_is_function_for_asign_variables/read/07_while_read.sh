#!/bin/bash
# http://server.etutsplus.com/sh-while-read-line-4pattern/

cnt=0
while read line
do
  cnt=`expr $cnt + 1`
  echo "LINE $cnt : $line"
done << END
ABC
DEF
GHK
END
# LINE 1 : ABC
# LINE 2 : DEF
# LINE 3 : GHK


cnt=0
echo "hoge\n\bar\npiyo" | while read line
do
  cnt=`expr $cnt + 1`
  echo "LINE $cnt : $line"
done
# LINE 1 : hogenbarnpiyo

cnt=0
cat sample.txt | while read line
do
  cnt=`expr $cnt + 1`
  echo "LINE $cnt : $line"
done
# LINE 1 : Hello World!
# LINE 2 : I am Hero.
# LINE 3 : I'll save you.

DATA=`cat sample.txt`
cnt=0
while read line
do
  cnt=`expr $cnt + 1`
  echo "LINE $cnt : $line"
done << END
$DATA
END
# LINE 1 : Hello World!
# LINE 2 : I am Hero.
# LINE 3 : I'll save you.

cnt=0
echo $DATA | while read line
do
  cnt=`expr $cnt + 1`
  echo "LINE $cnt : $line"
done
# LINE 1 : Hello World! I am Hero. I'll save you.

cnt=0
while read line
do
  cnt=`expr $cnt + 1`
  echo "LINE $cnt : $line"
done < sample.txt
# LINE 1 : Hello World!
# LINE 2 : I am Hero.
# LINE 3 : I'll save you.
