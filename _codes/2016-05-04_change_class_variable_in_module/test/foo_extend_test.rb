require_relative 'test_helper'

class FooExtendTest < Test::Unit::TestCase
  self.test_order = :defined

  test "variables" do
    # NameError: uninitialized class variable @@cls_val in FooExtend
    assert_raise NameError do FooExtend.cls_val end
    assert_nil FooExtend.cls_ins_val
    assert_nil FooExtend.new.cls_ins_val
  end

  test "can't change cls val module" do
    FooExtend.cls_val = "after"
    assert_equal "after", FooExtend.cls_val
    assert_equal "cls val", FooExtend.cls_val_module
  end

  test "take over cls val" do
    assert_equal "after", FooExtend.cls_val
    assert_equal "cls val", FooExtend.cls_val_module
  end

  test "change cls val module" do
    FooExtend.cls_val_module = "after"
    assert_equal "after", FooExtend.cls_val_module
  end

  test "hello" do
    assert_equal "hello", FooExtend.hello
  end
end
