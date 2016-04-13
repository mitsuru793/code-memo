module Module1
  class String; end

  def self.create_instance
    String.new "test"
  end
end

module Module2
  class String < ::String
  end

  def self.create_instance
    String.new "test"
  end

  def self.compare_string?
    String.equal?(::String)
  end
end
