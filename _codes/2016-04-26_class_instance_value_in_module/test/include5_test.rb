require_relative 'test_helper'

class Attr5Test < Test::Unit::TestCase
  test "NoMethodError from Class" do
    assert_raise NoMethodError do Include5.get_cls_ins_val end
    assert_raise NoMethodError do Include5.set_cls_ins_val("") end
    assert_raise NoMethodError do Include5.get_ins_val end
    assert_raise NoMethodError do Include5.set_ins_val("") end
  end

  test "" do
    obj = Include5.new
    assert_nil obj.get_cls_ins_val
    obj.set_cls_ins_val("after cls_ins_val")
    assert_equal "after cls_ins_val", obj.get_cls_ins_val
    assert_equal "default cls_val", obj.get_cls_val
    obj.set_cls_val("after cls_val")
    assert_equal "after cls_val", obj.get_cls_val
  end
end
