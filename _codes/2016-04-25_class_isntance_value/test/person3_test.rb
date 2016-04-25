require_relative 'test_helper'

class Person3Test < Test::Unit::TestCase
  test "initialize" do
    person = Person3.new
    assert_equal person.cls_ins_val,  'change cls_ins_val'
    assert_equal Person3.cls_ins_val, 'default cls_ins_val'

    assert_nil   person.cls_val
    assert_equal Person3.cls_val, 'change cls_val'
  end

  test "sub class" do
    class Sub < Person3; end
    sub = Sub.new

    assert_equal sub.cls_ins_val,  'change cls_ins_val'
    assert_nil Sub.cls_ins_val

    assert_nil   sub.cls_val
    assert_equal Sub.cls_val, 'change cls_val'
  end
end
