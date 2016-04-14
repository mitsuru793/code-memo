require_relative 'array'
require_relative 'string'

module MyModule
  using MyModule
  def self.string_hello
    String.new("").hello
  end

  def self.string_hello2
    ::String.new("").hello
  end

  def self.array_hello
    Array.new([]).hello
  end

  def self.array_hello2
    ::Array.new([]).hello
  end

  def self.get_empty_string
    String.new("")
  end
end
