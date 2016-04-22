require 'test/unit'
require 'awesome_print'

class Array
  def include_all?(other)
    other.all? {|other_value| include?(other_value)}
  end

  def include_any?(other)
    other.any? {|other_value| include?(other_value)}
  end
end

class Hash
  def include_all_hash?(other)
    other.each do |key, val|
      if has_key?(key)
        return false if fetch(key) != val
      else
        return false
      end
    end
    true
  end

  def include_any_hash?(other)
    other.each do |key, val|
      return true if has_key?(key) and fetch(key) == val
    end
    false
  end
end

class ArrayAndHashTest < Test::Unit::TestCase
  sub_test_case "Array" do
    test "#include?" do
      array = [1, 2, 3]
      assert array.include?(1)
      assert_false array.include?(-2)
    end

    test "#include_all?" do
      array = [1, 2, 3]
      assert array.include_all?([1, 2])
      assert_false array.include_all?([1, 0])
    end

    test "#include_any?" do
      array = [1, 2, 3]
      assert array.include_any?([1, 0])
      assert_false array.include_any?([-1, 0])
    end
  end

  sub_test_case "Hash" do
    test "#include?" do
      hash = {id: 1, name: "Mike", age: 20}
      assert hash.include?(:id)
      assert_false hash.include?("id")
      assert_false hash.include?(:from)
    end

    test "#include_all_hash?" do
      hash = {id: 1, name: "Mike", age: 20}
      assert hash.include_all_hash?(id: 1, name: "Mike")
      assert_false hash.include_all_hash?(id: 2, name: "Mike")
      assert_false hash.include_all_hash?(from: "Japan")

      hash = {
        item:
          {id: 1, name: "Mike"}
      }
      assert hash.include_all_hash?(item: {id: 1, name: "Mike"})
      assert_false hash.include_all_hash?(id: 1, name: "Mike")
    end

    test "#include_all_hash?" do
      hash = {id: 1, name: "Mike", age: 20}
      assert hash.include_all_hash?(id: 1, name: "Mike")
      assert_false hash.include_all_hash?(id: 2, name: "Mike")
      assert_false hash.include_all_hash?(from: "Japan")

      hash = {
        item:
          {id: 1, name: "Mike"}
      }
      assert hash.include_all_hash?(item: {id: 1, name: "Mike"})
      assert_false hash.include_all_hash?(id: 1, name: "Mike")
    end

    test "#include_any_hash?" do
      hash = {id: 1, name: "Mike", age: 20}
      assert hash.include_any_hash?(from: "Japan", age: 20)
      assert_false hash.include_any_hash?(id: 2, name: "Jane")
    end
  end
end
