require 'front_matter_parser'

class FrontMatterParser::Parsed
  def extend_hello
    "extend hello"
  end
end

module Extend
  class FrontMatterParser::Parsed
    def module_hello
      "module hello"
    end
  end
end

module RefineExtend
  refine FrontMatterParser::Parsed do
    def refine_hello
      "refine hello"
    end
  end
end

module InstanceExtend
  def instance_hello
    "instance hello"
  end
end
