module ExtendArray
  refine Array do
    def hello
      "Array hello"
    end
  end

  def say
    "ExtendArray module say"
  end
end

module IncludeArray
  class Array
    def include_hello
      "include hello"
    end
  end
end

class HasArray
  using ExtendArray
  include IncludeArray
  def hello_with_array(array)
    array.hello
  end

  def get_array
    [3,4]
  end

  def get_extend_array
    [5,6].extend(ExtendArray)
  end
end
