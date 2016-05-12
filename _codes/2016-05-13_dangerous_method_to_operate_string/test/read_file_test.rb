require_relative 'test_helper'

def add_string(content)
  content += "last\n"
end

def modify_first_line(content)
  content.each_line do |line|
    line = "after line"
    break
  end
end

def change_no1(original_str)
  str = original_str
  str.sub!('no.1', 'no.1 after')
end


def add_string!(content)
  new_content = content + "last\n"
  content.replace(new_content)
end

def modify_first_line!(content)
  new_content = []
  content.each_line.with_index(0) do |line, i|
    line = "after line\n" if i == 0
    new_content << line
  end
  content.replace(new_content.join)
end

class ReadFileTest < Test::Unit::TestCase
  def setup
    @load_buff = File.read('sample.txt')
  end
  test "add_string" do
    after_buff = add_string(@load_buff)
    assert_equal "last", after_buff.split("\n")[-1]
    assert_equal "no.5", @load_buff.split("\n")[-1]
  end

  test "modify_first_line" do
    modify_first_line(@load_buff)
    assert_equal "no.1", @load_buff.split("\n")[0]
  end

  test "change_no1" do
    change_no1(@load_buff)
    assert_equal "no.1 after", @load_buff.split("\n")[0]
  end

  test "add_string!" do
    after_buff = add_string!(@load_buff)
    assert_equal "last", after_buff.split("\n")[-1]
    assert_equal "last", @load_buff.split("\n")[-1]
  end
  test "modify_first_line!" do
    modify_first_line!(@load_buff)
    assert_equal "after line", @load_buff.split("\n")[0]
  end
end
