class Array; end

module MyModule
  class Array
    def inside_hello
      "hello"
    end
  end

  def self.get_array
    []
  end

  def self.get_new_array
    Array.new
  end

  def self.inside_hello
    [].inside_hello
  end

  def self.new_inside_hello
    Array.new.inside_hello
  end

  def self.is_inside_array?
    # モジュール内で拡張したArrayと比較
    [].is_a?(Array)
  end

  def self.is_top_array?
    # モジュールの外側で定義したArrayと比較
    [].is_a?(::Array)
  end

  def self.is_new_array?
    Array.new.is_a?(Array)
  end

  def self.is_new_top_array?
    ::Array.new.is_a?(Array)
  end

  class Foo
    def self.get_array
      []
    end

    def self.get_new_array
      Array.new
    end

    def self.inside_hello
      [].inside_hello
    end

    def self.new_inside_hello
      Array.new.inside_hello
    end
  end
end

class DoubleColonTest < Test::Unit::TestCase
  test "type" do
    assert_true MyModule.get_array.is_a?(Array)
    assert_false MyModule.is_inside_array?
    assert_true MyModule.is_top_array?
    assert_true MyModule.is_new_array?
    assert_false MyModule.is_new_top_array?
  end

  test "method" do
    assert_raise NoMethodError do MyModule.get_array.inside_hello end
    assert_equal MyModule.get_new_array.inside_hello, "hello"
    assert_raise NoMethodError do MyModule.inside_hello end
    assert_equal MyModule.new_inside_hello, "hello"
    assert_raise NoMethodError do MyModule::Foo.get_array.inside_hello end
    assert_equal MyModule::Foo.get_new_array.inside_hello, "hello"
    assert_raise NoMethodError do MyModule::Foo.inside_hello end
    assert_equal MyModule::Foo.new_inside_hello, "hello"
  end
end
