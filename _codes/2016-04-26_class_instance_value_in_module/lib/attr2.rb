module Attr2
  @cls_ins_val = "default cls_ins_val"
  @@cls_val    = "default cls_val"

  class << self
    attr_accessor :cls_ins_val, :cls_val
  end
end
