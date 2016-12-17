#!/bin/bash
# http://qiita.com/bsdhack/items/597eb7daee4a8b3276ba

echo ${foo} #
echo ${foo:-FOO} # FOO
echo ${foo} #

foo=after_foo
echo ${foo:-FOO} # after_foo


echo ${bar} #

echo ${bar:=BAR} # BAR
echo ${bar} # BAR
echo ${bar:=after_bar} # BAR


echo ${piyo} #
# echo ${poyo:?value not set}
# 02_expand.sh: line 20: poyo: value not set


echo ${fuga:+fuga} #
fuga=FUGA
echo ${fuga:+fuga} # fuga


echo ${baz} #
echo ${#baz} # 0
baz=BAZ
echo ${#baz} # 3


# %は後ろから、#は前から。2個連続になると最長。1個だと最短
foo=foo.example.com

echo ${foo%.*}      # foo.example
echo ${foo%e.com}   # foo.exampl
echo ${foo%example} # foo.example.com

echo ${foo%%.*}      # foo
echo $foo            # foo.example.com
echo ${foo%%e.com}   # foo.exampl
echo ${foo%%example} # foo.example.com

echo ${foo#*.} # example.com
