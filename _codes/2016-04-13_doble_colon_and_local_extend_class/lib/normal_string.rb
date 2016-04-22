class String
  def normal_hello
    "normal hello"
  end
end

module NormalModule
  class String
    def normal_module_hello
      "normal module hello"
    end
  end
end

module NormalUsingModule
  refine String do
    def normal_using_hello
      "normal using hello"
    end
  end
end

using NormalUsingModule

module NormalUsingModule2
  refine String do
    def normal_using_hello2
      "normal using hello2"
    end
  end
end
