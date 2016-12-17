require 'test/unit'
require 'awesome_print'
require 'fakefs'
require_relative '../lib/replace_line'

class ReplaceLineTest < Test::Unit::TestCase
  def setup
    content = <<-EOF
1. hello
2. world
3. hello
4. world
    EOF
    File.write('hello.txt', content)
  end

  test "replace_nth" do
    buff = File.read('hello.txt')
    three_line = replace_nth(buff, 'hello', 'after', 2).split("\n")[2]
    assert_equal three_line, '3. after'
  end

  test "String#each_line doesn't change reciever" do
    buff = File.read('hello.txt')
    buff.each_line do |line|
      line = 'after'
    end
    one_line = buff.split("\n")[0]
    assert_equal     one_line, '1. hello'
    assert_not_equal one_line, 'after'
  end
end
