require 'test/unit'
require 'awesome_print'

class NormalBase
  def initialize
    @instancep = "NormalBase#instancep"
  end

  def self.klass
    "NormalBase#klass"
  end

  def instance
    "NormalBase#instance"
  end
end

class NormalChildNothing < NormalBase
end

class NormalChildOverride < NormalBase
  def self.klass
    "NormalChildOverride#klass"
  end

  def instance
    "NormalChildOverride#instance"
  end
end

class NormalClassTest < Test::Unit::TestCase
  test "NormalChildNothing" do
    assert_equal NormalChildNothing.klass, "NormalBase#klass"
    assert_raise NoMethodError do NormalChildNothing.new.klass end
    assert_raise NoMethodError do NormalChildNothing.instance end
    assert_equal NormalChildNothing.new.instance, "NormalBase#instance"
  end
  test "NormalChildOverride" do
    assert_equal NormalChildOverride.klass, "NormalChildOverride#klass"
    assert_raise NoMethodError do NormalChildOverride.instance end
    assert_equal NormalChildOverride.new.instance, "NormalChildOverride#instance"
  end
end


module Base
  class ModuleBase
    def self.klass
      "ModuleBase#klass"
    end

    def instance
      "ModuleBase#instance"
    end
  end
end

module Child
  class ModuleChildNothing < Base::ModuleBase
  end

  class ModuleChildOverride < Base::ModuleBase
    def self.klass
      "ModuleChildOverride#klass"
    end

    def instance
      "ModuleChildOverride#instance"
    end
  end
end

class ModuleClassTest < Test::Unit::TestCase
  test "ModuleBase" do
    assert_equal Base::ModuleBase.klass, "ModuleBase#klass"
    assert_raise NoMethodError do Base::ModuleBase.new.klass end
    assert_raise NoMethodError do Base::ModuleBase.instance end
    assert_equal Base::ModuleBase.new.instance, "ModuleBase#instance"
  end

  test "ModuleChildNothing" do
    assert_equal Child::ModuleChildNothing.klass, "ModuleBase#klass"
    assert_equal Child::ModuleChildNothing.new.instance, "ModuleBase#instance"

    assert_equal Child::ModuleChildOverride.klass, "ModuleChildOverride#klass"
    assert_equal Child::ModuleChildOverride.new.instance, "ModuleChildOverride#instance"
  end
end
