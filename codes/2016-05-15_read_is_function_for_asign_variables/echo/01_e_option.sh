#!/bin/bash

# クオート内のエスケープに影響

# エスケープを解釈する
echo -e \ta   # ta
echo -e "\ta" #   a
echo -e '\ta' #   a

# エスケープを解釈しない
echo -E \ta   # ta
echo -E "\ta" # \ta
echo -E '\ta' # \ta

# no option a
echo -eEna # -eEna
