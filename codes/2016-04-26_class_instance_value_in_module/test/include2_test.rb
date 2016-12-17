require_relative 'test_helper'

class Include2Test < Test::Unit::TestCase
  test "class value" do
    obj = Include2.new
    assert_raise NoMethodError do obj.cls_ins_val end
    assert_raise NoMethodError do obj.cls_val end

    assert_raise NoMethodError do Include2.cls_ins_val end
    assert_raise NoMethodError do Include2.cls_val end
  end
end
