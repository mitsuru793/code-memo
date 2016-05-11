---
layout: code
title: WEBrickでプロキシサーバを作ってみる
date: 2016-05-11 17:20:41 +0900
tags: [ruby, webrick, proxy]
---

# サンプルファイル
3サイトのサンプルを実際に打ち込んで動かしてみました。

|ディレクトリ|参考|
|:-----------|:---|
|sample01|[Rubyで手っ取り早くWEB開発環境を用意する。WEBrick利用 - むかぁ～ どっと　こむ](http://mukaer.com/archives/2012/03/08/rubywebwebrick/)|
|mount_sample|[基本機能の実装にチャレンジ！ | Think IT（シンクイット）](https://thinkit.co.jp/article/117/2)|
|proxy_sample|[プロキシサーバーを作る！ | Think IT（シンクイット）](https://thinkit.co.jp/article/117/3)|

# WEBrickとは？

Webサーバーを手軽に拡張できるのがWEBrickとのこと。Apachモジュールで拡張しようとすると、大きなドキュメントを熟読する必要があるので敷居が高くなってしまいます。さらに言語がC言語になってしまう。

* Ruby 1.8以降に標準添付。
* フレームワークなので単体では起動できない。
* ソースコードが綺麗なので入門におすすめ。

## Apachとの違い

* モジュールの数
* 開発言語

## インデックス

これらの機能の名前を知りませんでした。

| 機能名                   | 意味                                       |
| :----------------------- | :----------------------------------------- |
| ディレクトリインデックス | `index.html`を補完                         |
| オートインデックス       | `index.html`がない時にファイルリストを表示 |

# 手動でContent-Typeを挿入

> Content-Typeがヘッダに含まれない場合、多くのWebブラウザはURLの拡張子を見て表示する方法を決めます。これはWebブラウザによって挙動が変わるので、できればHTTPサーバー側で返す必要があります。
>
> > <cite>[基本機能の実装にチャレンジ！ | Think IT（シンクイット）](https://thinkit.co.jp/article/117/2)</cite>

HTMLファイルを`image/jpeg`にして返しましたが、Chromeだと正常に表示されました。Chromeはファイルの内容で判断しているのかも。HTMLは最初に`DOCTYPE`を宣言するからわかりやすいですしね。

# プロキシのコード

最終的に次のようなコードになりました。localhostで実験する時には、下記のRubyファイルと同じ階層に`localhost`というディレクトリを作ります。ここにファイルを置いておけば優先して読み込まれます。ローカルファイルがある際は、HTTPサーバの同名のファイルは使われません。

`res.header['key']`の`key`は好きな文字列を入れることができます。それをどうブラウザが解釈するかわかりません。標準以外のも入れられることは覚えておくといいです。

```ruby
#!/usr/bin/env ruby
require 'webrick'
require 'webrick/httpproxy'
include WEBrick

class OriginalHTTPProxyServer < HTTPProxyServer
  def proxy_service(req, res)
    localfile = "#{req.host}/#{req.path}"
    if File.file?(localfile)
      res.body = open(localfile).read
      res.header["Content-Type"] = WEBrick::HTTPUtils.mime_type(req.path_info, WEBrick::HTTPUtils::DefaultMimeTypes)
      return
    end
    super
  end
end

s = OriginalHTTPProxyServer.new(Port: 8080)
trap("INT"){ s.shutdown }
s.start
```

# 自作プロキシを何に使うか？

RubyとWEBrickで手軽にプロキシを作って拡張できます。次のような簡単なことに使うといいかもしれません。

* ローカルネットで個人のアクセスを追跡する。
* コンテンツフィルタリング。
* CSSを変更して見た目を良くする。

最後のCSSのは、Chrome拡張で作ってもいいかもですね。でも、プロキシを一度踏むように設定すればプロキシサーバーをいじるだけで、全てのアクセスするPCを操作できるのが便利かな。一人だけならChrome拡張で、複数で統一を取りたいならプロキシサーバを立てるといいと思いました。

# WEBrickをステップアップするための記事

* [Rubyist Magazine - WEBrickでプロキシサーバを作って遊ぶ](http://magazine.rubyist.net/?0002-WEBrickProxy)
* [WEBRickプロキシでgzipに対応する - unnecessary words](http://d.hatena.ne.jp/hayori/20080205/1202189655)
