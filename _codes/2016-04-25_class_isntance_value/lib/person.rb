class Person
  attr_reader :name, :age

  def initialize
    @name = 'Yamada'
    age = 20
    @from = 'Japan'
    home = 'Aichi'

    p self # #<Person:0x007f867a0596e8 @name="Yamada", @from="Japan">
    p self.name  # "Yamada"
    p self.age   # nil
    #p self.from # NoMethodError
    #p self.home  # NoMethodError
  end
end
