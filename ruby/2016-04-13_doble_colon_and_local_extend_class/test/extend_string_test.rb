require_relative '../lib/extend_string'
class NormalStringTest < Test::Unit::TestCase
  test "no extend" do
    assert_true NoExtend.const_defined?(:String)
    assert_true NoExtend.const_defined?(:Array)

    assert_false NoExtend.compare_string?
    assert_true NoExtend.compare_string2?
    assert_true NoExtend.compare_string3?

    assert_true NoExtend.equal_string?
    assert_false NoExtend.equal_string2?
    assert_false NoExtend.equal_string3?
  end

  test "extend" do
    assert_true Extend.const_defined?(:String)
    assert_true Extend.const_defined?(:Array)

    assert_false Extend.compare_string?
    assert_false Extend.compare_string2?
    assert_true Extend.compare_string3?

    assert_false Extend.equal_string?
    assert_false Extend.equal_string2?
    assert_false Extend.equal_string3?
  end
end
