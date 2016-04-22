require_relative 'test_helper'

class TestArray < Test::Unit::TestCase
  test "#has_shape?" do
    shape = { id: Integer, name: String }
    assert({ id: 1, name: "Mike"}.has_shape?(shape))
    assert_false({ id: 1, first_name: "Mike"}.has_shape?(shape))
    assert_false({ id: 1, name: 00}.has_shape?(shape))

    shape = {
      id: Integer,
      items: { name: String, price: Integer }
    }
    hash = {
      id: 1,
      items: { name: "ball", price: 1000 }
    }
    assert(hash.has_shape?(shape))

    shape = {
      id: [Integer, Integer, Integer]
    }
    assert({id: [1, 2, 3]}.has_shape?(shape))
  end
end
