---
layout: code
title: ディレクトリ名の日付をファイル名の先頭につける
tags: [ruby]
date: 2016-04-22 00:00:00 +0900
---

複数のリポジトリを1つのリポジトリで管理するようにすると、下記のようなディレクトリ構造になると思います。ディレクトリ名が被らないように日付を付けています。

```
.
├── 2016-04-02_ruby_sample
│   └── README.md
└── 2016-04-12_python_sapmle
    └── README.md
```

これらの`README.md`はjekyllでは記事として扱われます。`README.md`のYAML Front Matterに`date`がないと、ファイル名の接頭辞の日付が使われます。今回は、`REAME.md`に`date`がないので、ディレクトリ名にある日付の接頭辞を`README.md`にも付けます。その処理を行う関数が`rename_adding_date_from_current_dir`です。リネーム対象を`glob`で決めれるので、`README.md`以外にも可能です。検索したファイルがあるディレクトリから日付を取得します。

```ruby
def rename_adding_date_from_current_dir(glob)
  Dir.glob(glob) do |path|
    current_dir_name = File.dirname(path)
    current_dir_basename = File.basename(current_dir_name)
    date_str = current_dir_basename.match(/\d{4}-\d{2}-\d{2}/)[0]
    new_file_name = date_str + '_' + File.basename(path)
    File.rename(path, File.join(current_dir_name, new_file_name))
  end
end

class RenameTest < Test::Unit::TestCase
  def setup
    FileUtils.rm(Dir.glob('*'))
    @dir_names = %w{2016-04-01_hello 2016-04-02_world}
    @dir_names.each do |dir_name|
      Dir.mkdir(dir_name)
      file_path = File.join('/', dir_name, 'README.md')
      File.write(file_path, '')
    end
  end

  test "rename_adding_date_from_current_dir" do
    rename_adding_date_from_current_dir('./*/README.md')
    paths = []
    Dir.glob('./**/*README.md') do |path|
      paths << path
    end

    assert_equal File.basename(paths[0]), '2016-04-01_README.md'
    assert_equal File.basename(paths[1]), '2016-04-02_README.md'
  end
end
```
