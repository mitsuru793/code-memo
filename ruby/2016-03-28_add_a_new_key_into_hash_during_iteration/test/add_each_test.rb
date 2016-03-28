require 'test/unit'
require 'awesome_print'

class AddEachTest < Test::Unit::TestCase
  test "array adds new element in iteration" do
    array1 = [1, 2]
    array2 = [3, 4]
    array2.each do |val|
      array1.push(val)
    end
    assert_equal array1, [1, 2, 3, 4]
    assert_equal array2, [3, 4]
  end

  test "hash files adding new element in iteration" do
    hash = {id: 1, name: "Mike"}
    assert_raise RuntimeError.new("can't add a new key into hash during iteration") do
      hash.each do |key, val|
        hash[key.to_s] = val
      end
    end
  end

  test "hash adds new element in iteration" do
    hash = {id: 1, name: "Mike"}
    keys = hash.keys.map {|v| v.to_s}
    assert_equal keys, ["id", "name"]

    keys.each do |key|
      hash[key] = hash[key.to_sym]
      hash.delete(key.to_sym)
    end
    assert_equal hash, {"id" => 1, "name" => "Mike"}
  end
end
