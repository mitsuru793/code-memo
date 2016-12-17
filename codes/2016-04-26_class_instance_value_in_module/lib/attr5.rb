module Attr5
  @cls_ins_val = "default cls_ins_val"
  @@cls_val    = "default cls_val"

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
end
