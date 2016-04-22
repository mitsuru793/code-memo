require_relative '../lib/root_string'
class RootStringTest < Test::Unit::TestCase
  test "use method" do
    assert_equal "".root_hello, "root hello"
    assert_equal RootModule.root_hello, "root hello"

    assert_raise NoMethodError do "".root_module_hello end
    assert_false RootModule.root_module_hello
    assert_equal RootModule.new_root_module_hello, "root module hello"

    assert_equal RootModule.root_hello, "root hello"
    assert_false RootModule.new_root_hello
    assert_equal RootModule.colon_new_root_hello, "root hello"

    assert_true RootModule.const_defined?(:String)
    assert_true RootModule.const_defined?(:Array)

    assert_false RootModule.compare_string?
    assert_true RootModule.compare_string2?
    assert_false RootModule.compare_string3?
  end
end
