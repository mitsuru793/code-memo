require_relative 'test_helper'

class AttrTest < Test::Unit::TestCase
  test "class instance value" do
    assert_equal "default cls_ins_val", Attr.get_cls_ins_val
    Attr.set_cls_ins_val("after cls_ins_val")
    assert_equal "after cls_ins_val", Attr.get_cls_ins_val

    assert_raise NoMethodError do Attr.cls_ins_val end
  end

  test "class value" do
    assert_equal "default cls_val", Attr.get_cls_val
    Attr.set_cls_val("after cls_val")
    assert_equal "after cls_val", Attr.get_cls_val

    assert_raise NoMethodError do Attr.cls_val end
  end

  test "class instance value has no default value" do
    assert_nil Attr.get_foo
    Attr.set_foo("hello")
    assert_equal "hello", Attr.get_foo

    assert_raise NoMethodError do Attr.foo end
  end
end
