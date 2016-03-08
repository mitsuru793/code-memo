require_relative 'test_helper'

class TestArray < Test::Unit::TestCase
  test "#has_shape?" do
    shape = [Integer, String]
    assert [1, "Mike"].has_shape?(shape)
    assert_false [1, 2].has_shape?(shape)

    shape = [Integer, [String, String]]
    assert [1, ["Mike", "Jane"]].has_shape?(shape)

    shape = [id: Integer, name: String]
    assert [{ id: 1, name: "Mike" }].has_shape?(shape)
  end
end
