require 'test/unit'
require 'awesome_print'
require 'chronic'

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
