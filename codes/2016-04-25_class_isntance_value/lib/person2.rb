class Person2
  attr_writer :name
  attr_reader :age

  def initialize
    self.name = 'Yamada'
    self.age  = 20 # NoMethodError
  end
end
