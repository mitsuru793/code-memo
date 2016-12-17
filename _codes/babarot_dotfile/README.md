---
layout: code
title: tesst
date: 2016-12-17 20:22:58 +0900
tags: [reading]
---

* [最強の dotfiles 駆動開発と GitHub で管理する運用方法 - Qiita](http://qiita.com/b4b4r07/items/b70178e021bef12cd4a2)
* [最新の dotfiles が正しくインストールされるか Travis CI でビルド・テストする - Qiita](http://qiita.com/b4b4r07/items/7232ceb1d7c3c5b6a83f)
* [優れた dotfiles を設計する | TELLME.TOKYO](http://tellme.tokyo/post/2015/07/16/dotfiles/)
[Man page of BASH](https://linuxjm.osdn.jp/html/GNU_bash/man1/bash.1.html)

# 何から手を付けるか？

リポジトリを落として全部使うより、読んで理解した部分から取り込んでいった方が勉強になるしいいと思います。そうじゃないと、いざ使おうとした時に問題が出ても、すぐに直せないかもしれません。この章では、何か取り込んでいいかを記します。

## 1. デプロイの自動化

ドットファイルへのシンボリックリンクをホームディレクトリに置く作業です。私は`dotfileLink.sh`という次のようなファイルを作って使っていました。全てのドットファイルの削除も自動化しておくといいでしょう。

```bash
#!/bin/sh
set -eu
basedir=$(pwd)

for f in .??*
do
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue
  ln -sf "${basedir}/${f}" "${HOME}/${f}"
done

rm -f "${HOME}/.bin"
rm -f "${HOME}/.template"
ln -sf "${basedir}/template/" "${HOME}/.template"
ln -sf "${basedir}/bin/" "${HOME}/.bin"
```

## 2. Makefileをつくる

ひとまず、上記のデプロイを`make`で実行出来るようにして置くといいでしょう。[initとinstallを2つのタスクに切り分ける理由は、こちらで解説されています。](http://tellme.tokyo/post/2015/07/16/dotfiles/)

次のように1ファイルにまとめて、オプションでタスクを実行にするようにすると`curl -L dot.example.com | bash -s -d`としないといけません。`curl -L dot.example.com`つぃて実行するためにもタスクをMakefileで分けています。

```bash
#!/bin/bash

deploy() {
  #...
  echo "deploy"
}

initalize() {
  #...
  echo "init"
}

if [ "$1" = "deploy" -o "$1" = "d" ]; then
  deploy
elif [ "$1" = "init" -o "$1" = "i" ; then
  initalize
fi
```

## 3. URLでDLしたら自動でinstallさせる

`bash -c "$(curl -L dot.b4b4r07.com)"`のURLは`raw.githubusercontent.com/b4b4r07/dotfiles/master/etc/install`にリダイレクトするようになっています。raw、つまり生のinstallファイルが標準出力に渡り、それを`bash -c`で実行させています。なので`bash -c "$(curl -L dot.b4b4r07.com)"`は、`etc/install`を実行させていることになります。

installからはdotfilesのDL、`make deploy`、`make init`が順に実行されるようになっています。DLでは、`https://github.com/b4b4r07/dotfiles/archive/master.tar.gz`がDLされます。[Githubではコミットにタグを打つとDLリンクが生成されます。](http://www.goodpic.com/mt/archives2/2010/08/github_tgzzip.html)

なので、makeを実行させるスクリプトrawで取得して実行させるだけでいいです。URLは短縮させるために別のからリダイレクトさせるといいでしょう。

## 4. テストを書く

dotfilesのテストを実行させるようにしましょう。


## 5. 便利なコマンドはbinに入れていく

`make deploy`でドットファイルと一緒に`~/bin`にデプロイされます。

# このdotfilesから学んだこと

bashの色々な文法について触れる事ができるのと、やっていることはシンプルなので初めてのソースコードリーディングに向いていると思います。ディレクトリ構造や呼び出し方の流れに慣れて、他の人のdotfilesも読めるようになるでしょう。

* bashのtips
* 使わないファイルはdiuseディレクトリに退避させる
* Makefileで必要とするタスク
* dotfilesのテストの仕方・何をテストするのか？
* 出力系など、覚えてにくいものはラッパー関数を作りまとめる。
* 役割ごとのディレクトリ構造

# Makefile

タスクはMakefileに定義されているので、ここを見ることでどのような役割、処理が定義されているかを把握することができます。

## Makefile内で完結

```
list:
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy:
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

update:
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

clean:
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	-rm -rf $(DOTPATH)
```

`$()`内に使われているコマンドは`bash`ではなく、Makefile独自のものです。下記で色々なものが紹介されています。

[Makefileの関数 - Qiita](http://qiita.com/chibi929/items/b8c5f36434d5d3fbfa4a)

## 外部スクリプトを使用

```
init:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh

test:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/test/test.sh

install: update deploy init
	@exec $$SHELL

```

今回読み進めいくのは`init`と`test`です。この2つは外部スクリプトになっています。`install`の`$$SHELL`ですが、ドルマークが2回続いているのはエスケープするためです。実際には`$SHELL`という環境変数を参照します。これには使っているシェルが入るので、私の場合は`exec /usr/local/bin/zsh`となり、zshが実行されます。

# initの流れ

```
init:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh
```

`make init`で初期化を実行することができます。

## initスクリプト

```bash
# etc/init/init.sh
# 一部省略しています。
# 1. カレントシェルでvital.shを実行
. "$DOTPATH"/etc/lib/vital.sh

# 2. osごとに用意したディレクトリ以下のshファイルを実行
for i in "$DOTPATH"/etc/init/"$(get_os)"/*.sh
do
  if [ -f "$i" ]; then
    log_info "$(e_arrow "$(basename "$i")")"
    if [ "${DEBUG:-}" != 1 ]; then
      bash "$i"
    fi
  else
    continue
  fi
done

log_pass "$0: Finish!!" | sed "s $DOTPATH \$DOTPATH g"
```

`vital.sh`はシンボリックリンクで、`etc/install`を指します。`get_os`はこの`etc/install`に定義されています。上記の1で`etc/install`を読み込んでいるから使えるわけです。`is_osx`や`is_bsd`などの関数もここに用意されており、そのラッパーが`get_os`です。例えば、osxなら`"osx"`を返します。

```bash
get_os() {
  local os
  for os in osx linux bsd; do
    if is_$os; then
      echo $os
    fi
  done
}
```

`etc/init/`には`linux/`, `osx/`というディレクトリがあります。`bsd`だけありません。macの時は`osx/`にある`~.sh`ファイルを全て実行します。つまり、Macの場合は初期化の処理は`etc/init/osx/`以下のシェルスクリプトに書かれていることになります。それを`make`で呼び出して実行しています。

## OSごとの初期化スクリプト

`etc/init/osx/`, `etc/init/linux/`両方に対応しているものはシンボリックリンクにしてあります。実体は`etc/common/`に置かれています。

**osx**

* 10_brew.sh
* 20_bundle.sh
* 30_go.sh -> ../common/go.sh
* 35_go_packages.sh -> ../common/go_packages.sh
* defaults.sh.disable
* git.sh -> ../common/git.sh
* pygments.sh -> ../common/pygments.sh
* unlocalize.sh
* xcode-cli.sh.disable
* zsh.sh -> ../common/zsh.sh

**linux**

* 20_git.sh -> ../common/git.sh
* 30_go.sh -> ../common/go.sh
* 35_go_packages.sh -> ../common/go_packages.sh
* pip.sh
* pygments.sh -> ../common/pygments.sh
* zsh.sh -> ../common/zsh.sh

これらはファイル名となっているソフトをインストールするスクリプトです。例として、`10_brew.sh`を見てます。数値で辞書順にすることで、実行順序を指定しています。これで依存関係を解決します。接頭辞の番号は手打ちだと思われます。

```bash
#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

# macで、brewとrubyがインストールされているかチェック
if ! is_osx; then
  log_fail "error: this script is only supported with osx"
  exit 1
fi

if has "brew"; then
  log_pass "brew: already installed"
  exit
fi

if ! has "ruby"; then
  log_fail "error: require: ruby"
  exit 1
fi

# インストールして異常がないかdoctorでチェック
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
if has "brew"; then
  brew doctor
else
  log_fail "error: brew: failed to install"
  exit 1
fi

log_pass "brew: installed successfully"
```

このように`etc/init/init.sh`からosごとに用意したディレクトリ内のシェルスクリプトを実行して、インストール作業をしています。インストールや初期化設定のスクリプトは、`etc/init/`のosに合ったディレクトリに追加していきましょう。

# テストの流れ

```
test:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/test/test.sh
```

`make test`でテストを実行できます。

## テストスクリプト 
役割は`etc/init/init.sh`と同じです。分割してあるシェルスクリプトを実行します。

```bash
# etc/test/test.sh
#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# 1つのテストファイルが失敗しても続く
for i in "$DOTPATH"/etc/test/*_test.sh
do
  bash "$i" || ERR=1
done

# osごとのテストを実行
if [ -n "$(get_os)" ]; then
  for i in "$DOTPATH"/etc/test/"$(get_os)"/*_test.sh
  do
    # ファイル以外はスキップ
    [ -f "$i" ] || continue
    bash "$i" || ERR=1
  done
fi

# 単体テスト数（1ファイルに複数のテストが書かれている場合あり）
n_unit=$(find "$DOTPATH"/etc/test -name "*_test.sh" | xargs grep "^unit[0-9]$" | wc -l | sed "s/ //g")
# テストファイル数
n_file=$(find "$DOTPATH"/etc/test -name "*_test.sh" | wc -l | sed "s/ //g")

echo "Files=$n_file, Tests=$n_unit"
[ "$ERR" = 1 ] && exit 1 || exit 0
```

## 初期化をどのようにテストしているか

実際のテストはどのように書かれているか、`etc/test/osx/init_brew_test.sh`を見てみます。

```bash
#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

unit1() {
  e_arrow "test brew.sh..."

  # インストールするシェルスクリプトが存在するか？
  if [ -f $DOTPATH/etc/init/osx/brew.sh ]; then
    e_success "check if init script exists" | e_indent
  else
    e_failure "$0: $LINENO: $FUNCNAME"
  fi

  # そのシェルスクリプトを走らせて、正常終了するか？
  if bash $DOTPATH/etc/init/osx/brew.sh; then
    e_success "check running" | e_indent
  else
    e_failure "$0: $LINENO: $FUNCNAME"
  fi
}

unit1
```

単体テストの関数名はunitと数字です。これで先程の`test.sh`の`xargs grep "^unit[0-9]$"`の部分で、単体テスト数を数えています。

スクリプトをただ実行しているだけで、細かいチェックはされていません。これは先述の`etc/init/osx/brew.sh`を見ればわかるのですが、失敗した場合は`exit 1`と異常終了するようにしています。初期化スクリプトの方でどうしたら失敗とするかを定義してあるので、テストファイルでそれを見るだけで済みます。だからこんなにシンプルなのです。

あくまで上記のファイルはシェルスクリプトがちゃんと走っているかをチェックしているだけで、brewがインストールされているかをチェックしているわけではなく、それは初期化スクリプト`brew.sh`に任せていることに注意してください。

## commonの設置

`init.sh`から各OSディレクトリのシェルスクリプトを実行させていることはわかりました。このディレクトリには、`etc/init/common/`にあるスクリプトへのシンボリックリンクが置いてあります。osxとlinux両方に必要な処理ですが、commonディレクトリを実行するわけでなく各OSのディレクトリ内を実行させています。なので、commonへのシンボリックリンクはosxとlinuxの両方に置く必要があるわけです。それを自動でやるスクリプトが`etc/init/platformize.sh`です。

```bash
# etc/init/platformize.sh
# 一部省略
link_sh() {
    log_echo "Any files ending in *.sh get symlinked into '$1'"

    # Change to platform directory
    builtin cd "$1"

    # Link sh files
    for i in ../common/*.sh
    do
        # overwritte if already exists
        #　前方最長一致である##*/でファイル名だけを取得
        ln -svf "$i" *${i##*/}
    done

    # cdすると1つ前のディレクトリが環境変数に保存される
    builtin cd "$OLDPWD"
}

link_sh "osx"
link_sh "linux"
```


## deploy test

* unit1 `make deploy`が正常終了するか。
* unit2 `$HOME`にあるドットファイルが、`$DOTPATH`のドットファイル指しているか。

unit2で`for i in $(make --silent list | sed "s|[*@/]$||g")`という記述がありますが、これはファイル以外を`sed`で削除しています。`make list`は`wildcard .??*`で取り出したドットファイルを`ls -dF`表示しています。ドットディレクトリなど、通常ファイル以外まで表示されてしまうので`sed`をフィルターとして使っています。

`$HOME`にあるドットファイルへのシンボリックリンクは、自作の`readlink`で実体へのパスを取得して`$DOTPATH`のものと比較しています。`deploy_test.sh`に書かれている`readlink`は`.path`にも定義されています。

## redirect_test

必要なコマンドのオプションは次の賞で解説してあります。

```bash
# etc/test/redirect_test.sh
# 一部省略
unit1() {
  # 1. 正常にダウンロードできるか
  # リダイレクトになっているかはチェックしていない
  curl -fsSL dot.b4b4r07.com >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    e_failure "$0: $LINENO: $FUNCNAME"
  fi

  # 2. リダイレクト元と先のURLで取得できるものは同じか
  diff -qs \
    <(wget -qO - dot.b4b4r07.com) \
    <(wget -qO - raw.githubusercontent.com/b4b4r07/dotfiles/master/etc/install) | \
    grep -q "identical"

  if [ $? -eq 0 ]; then
    e_done "redirecting dot.b4b4r07.com to github.com"
  else
    e_failure "$0: $LINENO: $FUNCNAME"
  fi
}
```

2の`grep -q "identical"`としている理由は、`diff`の同一ファイルは`Files foo.txt and bar.txt are identical`という風に表示させているためです。

## コマンドの確認

### curl

#### -f --fail
サーバーエラーが発生した時に、何も出力せずに終了させます。

#### -L --location
30xでRidirectが返ってくると、LocationヘッダのURLにアクセスします。

#### -s --silent
出力を止めます。一緒に`-S --show-error`を付けないと失敗時にはエラーも表示されません。

### wget

#### -q --quiet
出力を止めます。

#### -O --output-document
保存するファイル名を指定します。

### diff

#### -q  --brief
差異の内容ではなく、ァイル名を表示します。

#### -s --report-identical-files
通常はファイルに差異しか表示されないが、これを使えば同一の場合は同じですよと表示させることができます。

## シェルスクリプトの文法チェック

[shellcheck](https://github.com/koalaman/shellcheck)というツールでシェルスクリプトの文法をチェックします。配列`f`にチェックするファイルを入れて、ループで回して`shellcheck`を実行しているだけです。

```bash
unit1() {
  has "shellcheck" && :
  if [ $? -ne 0 ]; then
    return
  fi

  f=()
  f+=("$DOTPATH"/etc/init/*.sh)
  f+=("$DOTPATH"/etc/init/common/*.sh)
  f+=("$DOTPATH"/etc/init/osx/*.sh)
  f+=("$DOTPATH"/etc/init/linux/*.sh)

  e_arrow "check POSIX..."
  for i in "${f[@]}"
  do
    shellcheck "$i">/dev/null
    if [ $? -eq 0 ]; then
      e_success "$i" | e_indent
    else
      ERR=1
      e_failure "$i" | e_indent
    fi
  done

  if [ "$ERR" -eq 1 ]; then
    return 1
  fi
}
```

# installとvital.sh

dotfilesのダウンロードから、デプロイ、インストールまでの処理はここに書かれています。

## utility

dotfiles内で使う便利な関数はこで定義されています。自作コマンドを作る際にも便利でしょう。

### print

役割ごとに色を変えて出力するようにしています。eは`echo`の略かと。`noecho`はコメントには`echon`と同じとありますが動作が違う気がします。何のためにあるかわかりません。

* e_arrow
* e_done
* e_error
* e_failure
* e_header
* e_indent
* e_newline
* e_success
* e_warning
* echon
* noecho

```bash
# echon is a script to emulate the -n flag functionality with 'echo'
# for Unix systems that don't have that available.
echon() {
  echo "$*" | tr -d '\n'
}

# noecho is the same as echon
noecho() {
  if [ "$(echo -n)" = "-n" ]; then
    echo "${*:-> }\c"
  else
    echo -n "${@:-> }"
  fi
}
```

### log

`ink`は色を指定して、テキストを出力します。これを使って、ログの種類ごとに決まった色で出力するのが`logging`です。`log_~`は`logging`のラッパーです。色を考えて指定する必要がありません。

* ink
* logging
* log_echo
* log_fail
* log_info
* log_pass

```bash
ink <color> <text>
logging <fmt> <msg>
log_file <text>
```
### condition

各状態を判定する関数です。中身は1行とかなのですが、可読性が上がります。分かりづらい環境変数名とかはラップしておいた方がいいですね。1と0だけでなく、現在のOSの種類を取得などもあります。

* is_at_least
* is_bash
* is_bsd
* is_debug
* is_empty
* is_exists
* is_git_repo
* is_interactive
* is_linux
* is_login_shell
* is_number
* is_osx
* is_screen_or_tmux_running
* is_screen_running
* is_ssh_running
* is_tmux_runnning
* is_zsh
* shell_has_started_interactively
* has
* ostype
* shell_has_started_interactively
* get_os

```bash
# is_login_shell returns true if current shell is first shell
is_login_shell() {
    [ "$SHLVL" = 1 ]
}
```

### utility

* len
* lower
* upper
* contains
* die
* os_detect($PLATFORMにosの種類を入れる)
* path_remove($PATHから特定のpathを削除したものを返す)
* vitalize

```bash
vitalize() {
  return 0
}
```

## デプロイからインストール

次の4つの関数が定義されています。上3を順に呼び出しているのが`dotfiles_install`です。

* dotfiles_download
* dotfiles_deploy
* dotfiles_initialize
* dotfiles_install

### dotfiles_download

1. `$DOTPATH`が存在していたら失敗させる。
2. `git`があるなら`git clone`。
3. `git`がないなら`curl`か`wget`で`tar.gz`をDL。
4. `git`も`curl`も`wget`もないなら失敗させる。

### dotfiles_deploy

1. `$DOTPATH`が存在していたら失敗させる。
2. `$DOTPATH`へ移動。
3. `is_debug`ではないなら、`make deploy`。

### dotfiles_initialize

1. 第1引数が`"init"`、`is_debug`ではないなら処理開始。
2. `Makefile`があるなら`make init`。ないなら失敗。

### dotfiles_install

1. `dotfiles_download`を実行。
2. `dotfiles_deploy`を実行。
3. `dotfiles_initialize`に全ての引数を渡して実行。

## メイン処理

1. `$DOTPATH`がない場合は、デフォルト値の`~/.dotfiles`にする。
2. このリポジトリの`github`のURLを`$DOTFILES_GITHUB`に代入。
3. 呼びだされ方によって、処理を変える。

`source`で実行されたかどうかの判断は下記に方法が載っています。

[シェルスクリプトで親・子プロセスを判断する - Qiita](http://qiita.com/b4b4r07/items/d4b64227084f1209285a)

`source`で実行した場合は、環境変数`VITALIZED`を1にしています。`cat a.sh | bash`や`bash -c "$(cat a.sh)"`で実行した場合は、`dotfiles_install`が実行されます。

# シェルスクリプトのTips

## コロンの使い道

```bash
# etc/init/common/go.sh
# Cleaning
command mv -f "$grt"{,.$$} 2>/dev/null && :
command mv -f "$tar"{,.$$} 2>/dev/null && :
command mv -f "$dir"{,.$$} 2>/dev/null && :
```
`$$`はプロセスIDです。上記はファイルの末尾にプロセスIDを付けてリネームしています。同名ディレクトリが既に使われていた時を考えて、リネームで機能させないようにしているのでしょう。だから`rm`で削除していないと思います。

また、`:`を`&&`の後につけることによって、前のコードが1以上を返してもエラーにさせません。`:`は常に0を返すので、全体として0と評価されるようにできます。同名ディレクトリが存在していない時は`mv`がエラーになってしまうので、そこでスクリプトが終了しないようするための処置です。

[何もしない組み込みコマンド ":" （コロン）の使い道 - Qiita](http://qiita.com/xtetsuji/items/381dc17241bda548045d)

## 変数展開

```bash
# コロンより右側を消し、最優先されるPATHを取得。
sudo cp -f -v "$dir"/bin/go "${PATH%%:*}"

# スラッシュより左側を消し、ファイル名のみを取得。
uri="https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz"
tar="${uri##*/}"
```

## 一時的にエイリアスを無効にする

`command`、`builtin`コマンドを使うと一時的にエイリアスを無効にできます。コマンドの先頭に`\\`をつけても同様のことができます。[下記はmanの内容です。](https://linuxjm.osdn.jp/html/GNU_bash/man1/bash.1.html)2つのコマンドは少し動作が違います。

> command [-pVv] command [arg ...]
> command に引き数 args を付けて実行します。ただし、シェル関数の通常の参照は行いません。 組み込みコマンドと PATH 内で見つかるコマンドだけが実行されます。 -p オプションが与えられると、 command の検索を行う際に PATH のデフォルト値が使われます。これにより、 全ての標準ユーティリティを確実に見つけられます。 -V オプションまたは -v オプションを与えると、 command の説明が出力されます。 -v オプションでは、 command を起動するときに使われるコマンドやファイル名を示す単語が表示されます。 -V ではさらに詳しい説明が表示されます。 -V オプションや -v オプションを与えた場合、終了ステータスは command が見つかれば 0 となり、見つからなければ 1 となります。 どちらのオプションも与えなかった場合に、エラーが起きたり、 command を見つけられなかったりすると、終了ステータスは 127 になります。 それ以外の場合には、組み込みコマンド command の終了ステータスは、 command の終了ステータスです。

> builtin
> 指定されたシェル組み込みコマンドを実行します。コマンドには arguments を引き数として渡し、このコマンドの終了ステータスを返します。 これはシェル組み込みコマンドと同じ名前の関数を定義するときに便利で、 その関数内で組み込みコマンドの機能を使うことができます。 組み込みコマンド cd は普通、これを使って再定義されます。 shell-builtin がシェル組み込みコマンドでなければ、終了ステータスは偽となります。

## カレントシェルで実行

`. echo`ようにドットコマンドを使うとカレントシェルで実行できます。通常はシェルスクリプトはサブシェルで実行されるので、その中で`cd`とかしても終了するとカレントシェルは影響を受けません。定義した変数もなくなっていますよね。ですが、カレントシェルで実行させるのでシェルスクリプトの影響を受けるようになります。というより、シェルスクリプトを手打ちで打ち込んだと同じ状態です。

ドットコマンドの他に、`source`コマンドでも同様の結果が得られます。

## make --silent

`etc/test/deploy_test.sh`の`for i in $(make --silent list | sed "s|[*@/]$||g")`にある`make --list`ですが、これはコマンドを全て抑制するものです。通常は、@を付けないとmakeを実行した時にコマンド自体が出力されてしまいます。ですが、`--silent`をつければ全てのコマンドが@を付けたようにコマンド自体が出力されなくなります。

## if echo "$-" | grep -q "i"; then

`set`のオプションは`$-`で見れます。これはインタラクティブモードかをチェックしています。詳細は下記をどうぞ。

[シェルスクリプトで親・子プロセスを判断する - Qiita](http://qiita.com/b4b4r07/items/d4b64227084f1209285a)

## 変数未定義の場合のデフォルト値

`${val:-default}`はvalが定義されていない場合は、defaultを使います。`set -u`で、変数が未定義の場合にエラーにさせるようにしていると困る時もあります。そこで下記のように空文字列をデフォルト値にしたり、trueの1を入れたりしています。

```bash
if [ "$0" = "${BASH_SOURCE:-}" ]; then
if [ "${VITALIZED:=0}" = 1 ]; then
```

# TODO
## sudoのkeepalive
```bash
if [[ ! -f ~/.zplug/init.zsh ]]; then
  if (( ! $+commands[git] )); then
    echo "git: command not found" >&2
    exit 1
  fi

  git clone \
    https://github.com/zplug/zplug \
    ~/.zplug

  # failed
  if (( $status != 0 )); then
    echo "zplug: fails to installation of zplug" >&2
  fi
fi

if [ ${EUID:-${UID}} = 0 ]; then
  if chsh -s "$zsh_path" && :; then
    log_pass "[root] change shell to $zsh_path successfully"
  fi
fi
```

# 疑問

## etc/lib

これはどこから使わているかわかりませんでした。`etc/lib/standard.sh`にも`e_success`などの出力系が定義されています。dotfilesとは別で使うためのものかもしれませんね。何か開発する時にすぐに使えるライブラリということでしょうか。

## grtは何の略？

```bash
uri="https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz"
tar="${uri##*/}"
grt="/usr/local/go"
dir="go"
```
