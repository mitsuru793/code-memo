

# Makefile

```
__ALL_SRC__= .zshenv .zshrc
TARGET=$(__ALL_SRC__:%=%.zwc)

all: check $(TARGET)

check:
	@chmod a-x $(__ALL_SRC__)

%.zwc: %
	zsh -fc "zcompile $*"

clean:
	-@rm -f $(TARGET)
```

## 変数の置換

`$(val:old=new)`
valの中にあるoldをnewに置換します。先頭のドットを除いた完全一致でないといけません。部分一致にしたい場合は`%`を使います。

`%`はワイルドカード`*`にあたり、`old`の`%`でキャプチャして、それをnewの部分の`%`で参照できます。`old`で使わずに`new`で`%`を使うと、キャプチャしていないのでそのまま`%`が表示されます。


## コンパイル
`zsh -fc "zcompile $*"`
f
/etc/zshenvは読みこむが、ほかは読み込まない。

c
コマンドを文字列で渡す。

# 10_utils.zsh

```
has.command() {
    (( $+commands[${1:?too few argument}] ))
    return $status
}
```

commandsは連想配列です。この中に実行できるコマンドが入っています。そして`${1:?too few argument}`はキーを指定しています。この関数に引数を渡さなかった場合のデフォルト値が`too few argument`という文字列です。`$+`はその後に続く変数が存在するなら1、しないなら0と評価するものです。`${+foo}`とも`$+foo`とも書くことが出来ます。これは`${bar:?default}`のような変数展開の一種です。

最後の`(( ))`は中の値を数式と見なすことが出来るものです。`(( i++ ))`や`(( i += 3 ))`のように四則演算やインクリメントが出来ます。`foo=$(( ))`のようにドルをつけると結果を返り値となるので、それを代入させたりすることができます。この二重丸括弧の中で、スペースは無視されるのでスペースを入れても問題ありません。

`(($))`のように二重丸括弧の中でドルを使うと、これはそのプロセス番号を表示することになります。下記のスクリプトを`zsh tmp.zsh &`とバックグラウンド実行して、`ps`コマンドで確認してみてください。

```bash
echo $(($))
sleep 5
```

# 変数展開のコロンについて

`${foo:-default}`のように変数展開にはコロンがついているのをよく見かけますが、省略することもできます。そうすると、変数が未使用の時だけ`default`が使われることになります。`null`の場合は展開されません。

```bash
# nullをセット
foo=
echo ${foo:-default} # => default
echo ${foo-default}  # =>

echo ${bar:-default} # => default
echo ${bar-default}  # => default
```


```bash
cat_alias() {
  local i stdin file=0
  stdin=("${(@f)$(cat <&0)}")
  for i in "${stdin[@]}"
  do
    if [[ -f $i ]]; then
      cat "$@" "$i"
      file=1
    fi
  done
  if [[ $file -eq 0 ]]; then
    echo "${(F)stdin}"
  fi
}
```

`${(@f)$(cat <&0)}`は、`$(cat <&0)`で標準入力を受け取り`(@f)`で改行をスペースに変換して配列にしています。最後の`${(F)stdin}`はスペース区切りを改行にします。元に戻すということです。

```bash
pygmentize_alias() {
  if has "pygmentize"; then
    local get_styles styles style
    get_styles="from pygments.styles import get_all_styles
    styles = list(get_all_styles())
    print('\n'.join(styles))"
    styles=( $(sed -e 's/^  *//g' <<<"$get_styles" | python) )

    style=${${(M)styles:#solarized}:-default}
    cat_alias "$@" | pygmentize -O style="$style" -f console256 -g
  else
    cat -
  fi
}
```
