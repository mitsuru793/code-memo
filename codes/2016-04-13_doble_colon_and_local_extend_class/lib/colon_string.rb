class String
  def colon_hello
    "colon hello"
  end
end

module ColonModule
  class ::String
    def colon_module_hello
     "colon module hello"
    end
  end

  def self.colon_hello
    "RootModule.hello".colon_hello
  rescue NoMethodError
    false
  end

  def self.colon_module_hello
    "RootModule.hello".colon_module_hello
  rescue NoMethodError
    false
  end

  def self.new_colon_module_hello
    String.new.colon_module_hello
  rescue NoMethodError
    false
  end

  def self.colon_hello
    "RootModule.hello".colon_hello
  rescue NoMethodError
    false
  end

  def self.new_colon_hello
    String.new.colon_hello
  rescue NoMethodError
    false
  end

  def self.colon_new_colon_hello
    ::String.new.colon_hello
  rescue NoMethodError
    false
  end

  def self.compare_string?
    String === ::String
  end
end
