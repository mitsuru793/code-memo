require_relative 'hello'

class FooExtend
  extend Hello

  def self.cls_val=(val)
    @@cls_val = val
  end

  def self.cls_val
    @@cls_val
  end

  def self.cls_ins_val
    @cls_ins_val
  end

  def cls_ins_val
    @cls_ins_val
  end

  def self.hello
    cls_val_module = "hello"
    cls_val_module
  end
end
