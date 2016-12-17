require_relative 'test_helper'

class Attr2Test < Test::Unit::TestCase
  test "class instance value" do
    assert_equal "default cls_ins_val", Attr2.cls_ins_val
    Attr2.cls_ins_val = "after cls_ins_val"
    assert_equal "after cls_ins_val", Attr2.cls_ins_val
    assert_equal "after cls_ins_val", Attr2.cls_ins_val
  end

  test "class value" do
    assert_nil Attr2.cls_val
    Attr2.cls_val = "after cls_val"
    assert_equal "after cls_val", Attr2.cls_val
    assert_equal "after cls_val", Attr2.cls_val
  end
end
