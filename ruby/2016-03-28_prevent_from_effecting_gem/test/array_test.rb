require 'test_helper'

class ArrayTest < Test::Unit::TestCase
  test "extend" do
    has_array_obj = HasArray.new
    assert_equal has_array_obj.hello_with_array([1,2]), "Array hello"

    got_array = has_array_obj.get_array
    assert_equal got_array, [3, 4]
    assert_raise NoMethodError do got_array.hello end
    assert_raise NoMethodError do got_array.include end

    got_array = has_array_obj.get_extend_array
    assert_equal got_array, [5, 6]
    assert_raise NoMethodError do got_array.hello end
    assert_equal got_array.say, "ExtendArray module say"
    assert_raise NoMethodError do got_array.include end

    assert_raise NoMethodError do [].hello end
    assert_raise NoMethodError do [].say end
    assert_raise NoMethodError do [].include_hello end
  end
end
