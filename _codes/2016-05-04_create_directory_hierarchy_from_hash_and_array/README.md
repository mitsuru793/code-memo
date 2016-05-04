---
layout: code
title: HashとArrayからディレクトリ階層を作成する
tags: [ruby, test_helper]
date: 2016-05-04 22:53:25 +0900
---

ディレクトリ階層を`Array`と`Hash`で作成することができます。`Hash`の値が`Array`だとその`Hash`はディレクトリに、文字列だとファイルとのその中身を指定することになります。

```ruby
tree = [
  dir1: [],
  dir2: [
    :file1, :file2
  ],
  dir3: [
    file3 => 'This is file3 content'
  ]
]

CreateFileContentDir.create_tree_with_content()
```

```ruby
require 'fileutils'

class CreateFileContentDir
  class << self
    def create_tree_with_content(tree)
      case tree
      when Hash # Dir or File
        tree.each do |name, value|
          case value
          when String # name is File
            File.write(name.to_s, value)
          when Array # name is Dir
            old_path = Dir.pwd
            mkdir_cd(name.to_s)
            create_tree_with_content(value)
            Dir.chdir(old_path)
          end
        end
      when Array # Dirs or Files
        tree.each do |dir_file|
          create_tree_with_content(dir_file)
        end
      when *[String, Symbol] # Empty File
        FileUtils.touch(tree.to_s)
      end
    end

    def mkdir_cd(path)
      mkdir(path)
      Dir.chdir(path)
    end

    def mkdir(path)
      FileUtils.mkdir_p(path)
    end
  end
end
```
