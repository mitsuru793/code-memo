module Attr3
  @cls_val     = "default @cls_val"
  @@cls_val    = "default @@cls_val"

  class << self
    attr_accessor :cls_val
  end
end
