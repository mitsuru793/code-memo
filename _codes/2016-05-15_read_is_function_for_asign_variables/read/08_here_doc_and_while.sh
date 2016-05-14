#!/bin/bash

echo foo bar piyo | (read v1 v2 v3; declare -p ${!v*})
