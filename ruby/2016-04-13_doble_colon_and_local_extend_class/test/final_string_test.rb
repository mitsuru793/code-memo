require_relative '../lib/final_string'

class FinalStringTest < Test::Unit::TestCase
  test "another string" do
    assert_raise ArgumentError do Module1.create_instance end
  end

  test "extend string" do
    assert_equal Module2.create_instance, "test"
    assert_false Module2.compare_string?
  end
end
