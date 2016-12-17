module Attr
  @cls_ins_val = "default cls_ins_val"
  @@cls_val    = "default cls_val"

  attr_reader :cls_ins_val, :cls_val

  class << self
    def get_cls_ins_val
      @cls_ins_val
    end

    def set_cls_ins_val(val)
      @cls_ins_val = val
    end

    def get_cls_val
      @@cls_val
    end

    def set_cls_val(val)
      @@cls_val = val
    end

    def get_foo
      @foo
    end

    def set_foo(val)
      @foo = val
    end
  end
end
