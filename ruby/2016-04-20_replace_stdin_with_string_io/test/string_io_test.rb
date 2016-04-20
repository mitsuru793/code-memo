require 'test/unit'
class StringIOTEST < Test::Unit::TestCase
  test "standard test" do
    io = StringIO.new
    assert_equal io.lineno, 0
    io.puts('abcd')
    io.puts('efg')
    assert_equal io.lineno, 0

    assert_equal io.read, ''
    assert_true io.eof?
    io.rewind
    assert_false io.eof?
    assert_equal io.lineno, 0
    assert_equal io.read, "abcd\nefg\n"
    assert_equal io.lineno, 0
    assert_equal io.read, ''

    io.rewind
    assert_equal io.gets, "abcd\n"
    assert_equal io.lineno, 1
    assert_equal io.gets, "efg\n"
    assert_equal io.lineno, 2
    assert_nil io.gets
    assert_equal io.lineno, 2

    io.lineno = 0
    assert_equal io.lineno, 0
    assert_nil io.gets
    assert_equal io.lineno, 0
    io.rewind
    assert_equal io.gets, "abcd\n"
    assert_equal io.lineno, 1

    io = StringIO.new("abcdefg")
    assert_equal io.read, 'abcdefg'
  end
end
