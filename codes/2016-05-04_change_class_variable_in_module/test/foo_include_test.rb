require_relative 'test_helper'

class FooIncludeTest < Test::Unit::TestCase
  self.test_order = :defined

  test "variables" do
    assert_equal "cls val", FooInclude.cls_val
    assert_nil FooInclude.cls_ins_val
    assert_nil FooInclude.new.cls_ins_val
  end

  test "change cls val in class" do
    FooInclude.cls_val = "after"
    assert_equal "after", FooInclude.cls_val
    assert_equal "after", FooInclude.new.cls_val_module
  end

  test "take over cls val" do
    assert_equal "after", FooInclude.cls_val
    assert_equal "after", FooInclude.new.cls_val_module
  end

  test "change cls val in module" do
    FooInclude.new.cls_val_module = "after2"
    assert_equal "after2", FooInclude.cls_val
    assert_equal "after2", FooInclude.new.cls_val_module
  end
end
