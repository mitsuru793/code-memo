require_relative 'test_helper'

class Person2Test < Test::Unit::TestCase
  test "initialize" do
    expected = NoMethodError # undefined method `age=' for #<Person2:0x007f8c2380faa0>
    assert_raise expected do Person2.new end
  end
end
