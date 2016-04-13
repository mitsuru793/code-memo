require_relative '../lib/normal_string'
class NormalStringTest < Test::Unit::TestCase
  using NormalUsingModule2
  test "use method" do
    assert_equal "".normal_hello, "normal hello"
    assert_raise NoMethodError do "".normal_module_hello end
    assert_raise NoMethodError do "".normal_using_hello end
    assert_equal "".normal_using_hello2, "normal using hello2"
  end
end
