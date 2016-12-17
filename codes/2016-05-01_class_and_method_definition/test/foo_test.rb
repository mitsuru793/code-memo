require_relative 'test_helper'

class Foo1Test < Test::Unit::TestCase
  class Foo
    def Foo.hello
      "hello"
    end
  end

  test "add a method to instance" do
    assert_equal Foo.hello, "hello"

    foo1 = Foo.new
    assert_raise NoMethodError do foo1.hey end
    class << foo1
      def hey
        "foo1 hey"
      end
    end
    assert_equal foo1.hey, "foo1 hey"

    foo2 = Foo.new
    assert_raise NoMethodError do foo2.hey end
  end

  test "add a method to Class" do
    class << Foo
      def tell
        "tell"
      end
    end
    assert_equal "tell", Foo.tell
  end

  Bar = Class.new do
    def hey
      "hey"
    end
  end

  def Bar.tell
    "tell"
  end

  test "methods" do
    bar = Bar.new
    assert_equal bar.hey, "hey"
    assert_equal "tell", Bar.tell
  end
end
