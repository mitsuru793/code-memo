class MyApp
  attr_accessor :input, :output

  def initialize
    self.input = $stdin
    self.output = $stdout
  end

  def say
    output.puts(input.gets.chomp)
  end
end
