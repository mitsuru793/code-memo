#!/bin/bash
for f in test/*
do
  [[ "$f" == *test_helper.rb ]] && continue
  ruby $f
done
