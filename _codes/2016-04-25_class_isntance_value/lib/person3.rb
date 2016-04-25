class Person3
  @cls_ins_val = "default cls_ins_val"
  @@cls_val    = "default cls_val"
  attr_reader :cls_ins_val, :cls_val

  def initialize
    @cls_ins_val = 'change cls_ins_val'
    @@cls_val    = 'change cls_val'
  end

  def self.cls_ins_val
    @cls_ins_val
  end

  def self.cls_val
    @@cls_val
  end
end
