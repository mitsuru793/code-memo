require_relative 'test_helper'

class Attr3Test < Test::Unit::TestCase
  test "class value" do
    assert_equal     "default @cls_val",  Attr3.cls_val
    assert_not_equal "default @@cls_val", Attr3.cls_val
  end
end
