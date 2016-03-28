require 'test/unit'
require 'awesome_print'

module ExtendArray
  refine Array do
    def hello
      "extend array hello"
    end
  end
end

class Array
  def say
    "global array say"
  end
end

class ArrayA
  VAL = [1, 2]
end

class ArrayB
  using ExtendArray
  VAL = [3, 4]
  def self.instance_hello
    VAL.hello
  end

  def self.get_array
    [5, 6]
  end
end

class ExtendInsideModuleTest < Test::Unit::TestCase
  test "extend with using" do
    assert_equal ArrayA::VAL, [1, 2]
    assert_equal ArrayA::VAL.say, "global array say"
    assert_raise NoMethodError do ArrayA::VAL.hello end

    assert_equal ArrayB::VAL, [3, 4]
    assert_equal ArrayB::VAL.say, "global array say"
    assert_raise NoMethodError do ArrayB::VAL.hello end
    assert_equal ArrayB.instance_hello, "extend array hello"
  end

  test "not use return value" do
    array = ArrayB.get_array
    assert_equal array, [5, 6]
    assert_raise NoMethodError do array.instance_hello end
  end
end

module ExtendHello
  def hello
    "ExtendHello hello"
  end
end

module ExtendSay
  def say
    "ExtendSay say"
  end
end

class MyHash
  def self.get_hash
    {}.extend(ExtendHello, ExtendSay)
  end
end

class ExtendOnlyReturnTest < Test::Unit::TestCase
  test "exnted only return value" do
    my_hash = MyHash.get_hash
    assert_equal my_hash.hello, "ExtendHello hello"
    assert_equal my_hash.say, "ExtendSay say"

    assert_raise NoMethodError do {}.hello end
    assert_raise NoMethodError do {}.say end
  end
end
