require 'test/unit'
require_relative '../exe/main'

class HelloTest < Test::Unit::TestCase
  test "hello" do
    $stdin = StringIO.new("hello\nworld\n")
    out = capture_output { Command.start(%w{hello -t hoge}) }[0]
    assert_equal out, "hello\nworld\n"
  end

  test "hello2" do
    $stdin = StringIO.new
    $stdin.puts("hello")
    $stdin.puts("world")
    $stdin.rewind
    out = capture_output { Command.start(%w{hello -t hoge}) }[0]
    assert_equal out, "hello\nworld\n"
  end

  test "hello3" do
    out = capture_output { Command.start(%w{hello -t hoge}) }[0]
    assert_equal out, "no pipe\n"
  end

  test "say" do
    $stdin = StringIO.new("hello")
    out = capture_output { Command.start(%w{hello -t hoge}) }[0]
    assert_equal out, "hello\n"
  end
end
