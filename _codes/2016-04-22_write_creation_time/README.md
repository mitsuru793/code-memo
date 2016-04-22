---
layout: code
title: macでファイルの作成日時をYAML Front Matterに書き込む
tags: [ruby, bash, mac, yaml]
---

# テストコードの概要

1. 現在時刻を取得
2. 空ファイルを作成
3. 2のファイルの作成日時を、1の時刻に変更する。
4. ファイル内容を更新
5. ファイルを読み込み、3行目を取得して確認。

わざわざ3でファイル作成日時を変更しているのは、アサーションで日付を確認しやすくするためです。変数に入れておけば手打ちをする必要がないですよね。

```ruby
class FileTimeTest < Test::Unit::TestCase
  def self.startup
    @@file_name = 'hello_world.txt'
  end

  def self.shutdown
    File.delete(@@file_name)
  end

  def tearwdown
    File.delete(@@file_name)
  end

  test "write file creation time" do
    time_now = Time.now
    time_now_str = time_now.strftime('%m/%d/%Y %H:%M:%S')
    File.write(@@file_name, '')

    `setfile -d '#{time_now_str}' #{@@file_name}`
    create_time = `getFileInfo -d #{@@file_name}`.chomp
    content = <<-EOF
---
title: hello world
tags: [post]
date: #{Chronic.parse(create_time)}
---
Here is content.
    EOF
    File.write(@@file_name, content)

    three_line = File.read(@@file_name).split("\n")[3]
    assert_equal three_line, "date: #{time_now}"
  end
end
```

# ファイルの作成日時
Macだとファイルの作成日時が保存されており、ファイルの各情報は`getFileInfo`で取得できます。どちらもMacの機能です。このコードを実行する前に、`getFileInfo`の存在と、作成日時がファイルシステムに記録されているかを確認する必要があります。

# fakefsは使わない
`fakefs`はrubyのクラスをモックに置き換えてくれるものです。シェルコマンドを実行する際は、実際にファイルが作られてしまいます。そのため、今回は`fakefs`は使わないことにしました。
