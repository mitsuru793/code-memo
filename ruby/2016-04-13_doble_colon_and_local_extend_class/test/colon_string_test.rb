require_relative '../lib/colon_string'
class ColonStringTest < Test::Unit::TestCase
  test "use method" do
    assert_equal "".colon_hello, "colon hello"
    assert_equal ColonModule.colon_hello, "colon hello"

    assert_equal "".colon_module_hello, "colon module hello"
    assert_equal ColonModule.colon_module_hello, "colon module hello"
    assert_equal ColonModule.new_colon_module_hello, "colon module hello"

    assert_equal ColonModule.colon_hello, "colon hello"
    assert_equal ColonModule.new_colon_hello, "colon hello"
    assert_equal ColonModule.colon_new_colon_hello, "colon hello"

    assert_true ColonModule.const_defined?(:String)
    assert_true ColonModule.const_defined?(:Array)

    assert_false ColonModule.compare_string?
  end
end
