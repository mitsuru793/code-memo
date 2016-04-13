class String
  def root_hello
    "root hello"
  end
end

module RootModule
  class String
    def root_module_hello
      "root module hello"
    end
  end

  def self.root_hello
    "RootModule.hello".root_hello
  rescue NoMethodError
    false
  end

  def self.root_module_hello
    "RootModule.hello".root_module_hello
  rescue NoMethodError
    false
  end

  def self.new_root_module_hello
    String.new.root_module_hello
  rescue NoMethodError
    false
  end

  def self.root_hello
    "RootModule.hello".root_hello
  rescue NoMethodError
    false
  end

  def self.new_root_hello
    String.new.root_hello
  rescue NoMethodError
    false
  end

  def self.colon_new_root_hello
    ::String.new.root_hello
  rescue NoMethodError
    false
  end

  def self.compare_string?
    String === ::String
  end

  def self.compare_string2?
    "".is_a?(::String)
  end

  def self.compare_string3?
    "".is_a?(String)
  end
end
