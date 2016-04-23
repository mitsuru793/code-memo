require 'test/unit'
require 'fileutils'
require 'fakefs'
require_relative '../lib/add_date'

class AddDateTest < Test::Unit::TestCase
  def setup
    FileUtils.rm(Dir.glob('*'))
  end

  test "add_date_of_current_dir_to_front_matter" do
    dir_name  = '2016-04-22_dir1'
    Dir.mkdir(dir_name)
    file_path = File.join(dir_name, 'README.md')
    content = <<-EOF
---
title: hello world
tags: [post]
---
Here is content.
    EOF
    File.write(file_path, content)
    add_date_of_current_dir_to_front_matter('*/README.md')
    new_content = <<-EOF
---
title: hello world
tags: [post]
date: 2016-04-22 00:00:00 +0900
---
Here is content.
    EOF
    assert_equal File.read(file_path), new_content
  end

  sub_test_case "get_date_str_of_current_dir" do
    setup do
      @dir_name  = '2016-04-22_dir1'
      Dir.mkdir('./' + @dir_name)
    end

    test "when arg is dir" do
      assert_equal get_date_str_of_current_dir(@dir_name), '2016-04-22'
    end

    test "when arg is file" do
      file_path = File.join(@dir_name, 'README.md')
      File.write(file_path, 'this is content')
      assert_equal get_date_str_of_current_dir(file_path), '2016-04-22'
    end
  end

  test "get_lineno" do
    content = <<-EOF
1. hello
2. world
3. fin
4. world
    EOF
    assert_equal get_lineno(content, 'world', 2), 4
  end

  test "add_line" do
    content = <<-EOF
1. hello
3. fin
    EOF

    new_content = <<-EOF
1. hello
2. world
3. fin
    EOF
    assert_equal add_line(content, '2. world', 2), new_content
  end
end
