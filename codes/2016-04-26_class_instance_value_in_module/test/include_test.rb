require_relative 'test_helper'

class IncludeTest < Test::Unit::TestCase
  test "class instance value" do
    assert_raise NoMethodError do Include.get_cls_ins_val end
    assert_raise NoMethodError do Include.set_cls_ins_val("after cls_ins_val") end

    assert_raise NoMethodError do Include.cls_ins_val end

    obj = Include
    assert_raise NoMethodError do obj.get_cls_ins_val end
    assert_raise NoMethodError do obj.set_cls_ins_val("after cls_ins_val") end

    assert_raise NoMethodError do obj.cls_ins_val end
  end

  test "accessor" do
    assert_raise NoMethodError do Include.cls_ins_val end
    assert_raise NoMethodError do Include.cls_val end

    obj = Include
    assert_raise NoMethodError do obj.cls_ins_val end
    assert_raise NoMethodError do obj.cls_val end
  end
end
