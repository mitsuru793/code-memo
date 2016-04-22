require_relative '../lib/my_module.rb'

class MyModuleTest < Test::Unit::TestCase
  test "hello" do
    assert_equal MyModule.string_hello, "String Hello"
    assert_equal MyModule.string_hello2, "String Hello"
    assert_equal MyModule.array_hello, "Array Hello"
    assert_equal MyModule.array_hello2, "Array Hello"
  end
end
