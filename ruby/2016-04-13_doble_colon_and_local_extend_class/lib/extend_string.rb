module NoExtend
  def self.compare_string?
    String === ::String # false
  end

  def self.compare_string2?
    String === "" # true
  end

  def self.compare_string3?
    ::String === "" # true
  end

  def self.equal_string?
    String.equal?(::String) # true
  end

  def self.equal_string2?
    String.equal?("") # false
  end

  def self.equal_string3?
    ::String.equal?("") # false
  end
end

module Extend
  class String; end

  def self.compare_string?
    String === ::String # false
  end

  def self.compare_string2?
    String === "" # false
  end

  def self.compare_string3?
    ::String === "" #true
  end

  def self.equal_string?
    String.equal?(::String) # false
  end

  def self.equal_string2?
    String.equal?("") # false
  end

  def self.equal_string3?
    ::String.equal?("") # false
  end
end
