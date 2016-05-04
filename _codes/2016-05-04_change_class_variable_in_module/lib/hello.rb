module Hello
  @cls_ins_val = "cls ins val"
  @@cls_val = "cls val"

  def cls_val_module
    @@cls_val
  end

  def cls_val_module=(val)
    @@cls_val = val
  end
end
