#!/bin/bash

function asterisk() { echo "$*"; }
function at_sign()  { echo "$@"; }

asterisk foo bar piyo # foo bar piyo
at_sign foo bar piyo  # foo bar piyo

function asterisk_if() {
  if [ "$@" != "" ]; then
    echo "$@"
  else
    echo asterisk empty
  fi
}

asterisk_if foo # foo

# [: !=: unary operator expected
asterisk_if     # asterisk empty

function at_sign_if() {
  if [ "$*" != "" ]; then # [: bar: unary operator expected
    echo "$*"
  else
    echo at sign empty
  fi
}

at_sign_if bar # bar
at_sign_if     # at sign empty

ary=(1 2 3)
echo "${ary[*]}" # 1 2 3
echo "${ary[@]}" # 1 2 3
