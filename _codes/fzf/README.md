---
layout: code
title:
date:
tags: []
---

# option
## fzf

```text
-q, --query=STR
       Start the finder with the given query

-1, --select-1
       Automatically select the only match
-0, --exit-0
       Exit immediately when there's no match

--expect=KEY[,..]
       Comma-separated list of keys that can be used to complete fzf in  addition  to
       the default enter key. When this option is set, fzf will print the name of the
       key pressed as the first line of its output (or as the second line if --print-
       query  is  also  used).  The  line  will be empty if fzf is completed with the
       default enter key.
       e.g. fzf --expect=ctrl-v,ctrl-t,alt-s,f1,f2,~,@

       --tac  Reverse the order of the input
              e.g. history | fzf --tac --no-sort

```

## grep

```text
     -Z, -z, --decompress
             Force grep to behave as zgrep.
```

# Opening files

```
f# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  IFS='
'
  local declare files=($(fzf-tmux --query="$1" --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
  unset IFS
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  out=$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

```

```
# vf - fuzzy open with vim from anywhere
# ex: vf word1 word2 ... (even part of a file name)
# zsh autoload function
local files

files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})

if [[ -n $files ]]
then
   vim -- $files
   print -l $files[1]
fi
```

# Changing directory

```
# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

fdr() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$(pwd)}") | fzf-tmux --tac)
  cd "$DIR"
}
```

# locateコマンドが実行できるのには時間がかかる

```
❯ locate photo

WARNING: The locate database (/var/db/locate.database) does not exist.
To create the database, run the following command:

  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

Please be aware that the database can take some time to generate; once
the database has been created, this message will no longer appear.
```

# 参考

* [逆引きシェルスクリプト/スペースが含まれる文字列を1行として扱う方法 - Linuxと過ごす](http://linux.just4fun.biz/%E9%80%86%E5%BC%95%E3%81%8D%E3%82%B7%E3%82%A7%E3%83%AB%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%88/%E3%82%B9%E3%83%9A%E3%83%BC%E3%82%B9%E3%81%8C%E5%90%AB%E3%81%BE%E3%82%8C%E3%82%8B%E6%96%87%E5%AD%97%E5%88%97%E3%82%921%E8%A1%8C%E3%81%A8%E3%81%97%E3%81%A6%E6%89%B1%E3%81%86%E6%96%B9%E6%B3%95.html)
* [bash のビルトインコマンド “local” について - いままでのこと](http://blog.tekito.org/2010/11/23/bash-%E3%81%AE%E3%83%93%E3%83%AB%E3%83%88%E3%82%A4%E3%83%B3%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89-local-%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6/)
* [シェル変数と環境変数の違いをコマンドラインで確認する - Qiita](http://qiita.com/kure/items/f76d8242b97280a247a1)
* [Here Strings](http://linux.die.net/abs-guide/x15683.html)
* [Bash1543](http://qiita.com/ogiw/items/ac77a3bbb813351099a1)
* [zgrep - コマンド (プログラム) の説明 - Linux コマンド集 一覧表](http://kazmax.zpp.jp/cmd/z/zgrep.1.html)
* [findコマンドの-pruneオプションのススメ | roshi.tv::blog](http://www.roshi.tv/2011/02/find-prune.html)