require_relative 'test_helper'

class PersonTest < Test::Unit::TestCase
  test "initialize" do
    person = Person.new
    assert_equal person.name, 'Yamada'
    assert_nil person.age
    assert_raise NoMethodError do person.from end
    assert_raise NoMethodError do person.home end
  end
end
