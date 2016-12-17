---
layout: code
title:
date: 2016-06-10 01:18:30 +0900
tags: []
---

# [holman](https://github.com/holman/dotfiles)

## インストールの流れ

```shell
git clone https://github.com/holman/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

### script/bootstrap

1. gitconfigのメールアドレスとユーザ名を書き換える
2. ドットファイルの配置
3. Macの場合はbin/dotを実行

* ドットファイルの配置にはバックアップ作成やスキップなどのオプションが指定可能です。
* `*.symlink`というファイルをドットファイルとして配置します。もちろん、`.symlink`の部分は取り除かれます。

### bin/dot

1. ./homebrew/install.sh
2. ./osx/install.sh
3. brew update
4. script/install

#### ./homebrew/install.sh

Linuxの時はLinuxbrewをインストールします。

#### ./osx/install.sh

`sudo softwareupdate -i -a`を実行するだけです。

### script/install

1. brew bundle
2. 各ディレクトリにあるinstall.shを実行

現在のinstall.shは3つです。

* ./homebrew/install.sh
* ./node/install.sh
* ./osx/install.sh

### インストール完了

これでインストールは終わりです。まとめると下記のことを行いました。

1. gitのアカウント設定
2. ドットファイルのデプロイ
3. brewでのインストール
4. 他のパッケマネージャーでのinstall

`instlal.sh`が用意されていますが、それはソフトのインストールするコマンドのみなので多くても数行のものです。MacでもLinuxでもBrewで管理しているので、`install.sh`はパッケマネージャーに関してのみになっています。

## zshrc

* `~/.localrc`を読み込むので、ローカル設定はここに書く。
* 各ディレクトリにある`~.zsh`は自動で読み込まれます。
* functionsディレクトリは`zsh/config.zsh`にてfpathに追加されます。

`~.zsh`ですが、この中でも`path.zsh`と`completion.zsh`は分けて読み込まれます。下記の2はこの2つ以外です。

読み込み順序
1. path.zsh
2. ~.zsh
3. completion.zsh

