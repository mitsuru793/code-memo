require_relative 'test_helper'

class Object
  def self.object_class_method
    "object class method"
  end

  def object_instance_method
    "object instance method"
  end
end

class Module
  def self.module_class_method
    "module class method"
  end

  def module_instance_method
    "module instance method"
  end
end

class Class
  def self.class_class_method
    "class class method"
  end

  def class_instance_method
    "class instance method"
  end
end

class HooTest < Test::Unit::TestCase
  sub_test_case "Object" do
    test "object method" do
      assert_equal "object class method",    Object.object_class_method
      assert_equal "object instance method", Object.object_instance_method

      assert_raise NoMethodError do Object.new.object_class_method end
      assert_equal "object instance method", Object.new.object_instance_method
    end

    test "module method" do
      assert_raise NoMethodError do Object.module_class_method end
      assert_equal "module instance method", Object.module_instance_method

      assert_raise NoMethodError do Object.new.module_class_method end
      assert_raise NoMethodError do Object.new.module_instance_method end
    end

    test "class method" do
      assert_raise NoMethodError do Object.class_class_method end
      assert_equal "class instance method", Object.class_instance_method

      assert_raise NoMethodError do Object.new.class_class_method end
      assert_raise NoMethodError do Object.new.class_instance_method end
    end
  end

  sub_test_case "Module" do
    test "object method" do
      assert_equal "object class method",    Module.object_class_method
      assert_equal "object instance method", Module.object_instance_method

      assert_raise NoMethodError do Module.new.object_class_method end
      assert_equal "object instance method", Module.new.object_instance_method
    end

    test "module method" do
      assert_equal "module class method",    Module.module_class_method
      assert_equal "module instance method", Module.module_instance_method

      assert_raise NoMethodError do Module.new.module_class_method end
      assert_equal "module instance method", Module.new.module_instance_method
    end

    test "class method" do
      assert_raise NoMethodError do Module.class_class_method end
      assert_equal "class instance method", Module.class_instance_method

      assert_raise NoMethodError do Module.new.class_class_method end
      assert_raise NoMethodError do Module.new.class_instance_method end
    end
  end

  sub_test_case "Class" do
    test "object method" do
      assert_equal "object class method",    Class.object_class_method
      assert_equal "object instance method", Class.object_instance_method

      assert_equal "object class method", Class.new.object_class_method
      assert_equal "object instance method", Class.new.object_instance_method
    end

    test "module method" do
      assert_equal "module class method",    Class.module_class_method
      assert_equal "module instance method", Class.module_instance_method

      assert_raise NoMethodError do Class.new.module_class_method end
      assert_equal "module instance method", Class.new.module_instance_method
    end

    test "class method" do
      assert_equal "class class method",    Class.class_class_method
      assert_equal "class instance method", Class.class_instance_method

      assert_raise NoMethodError do Class.new.class_class_method end
      assert_equal "class instance method", Class.new.class_instance_method
    end
  end

  sub_test_case "My Class" do
    Foo = Class.new
    test "object method" do
      assert_equal "object class method", Foo.object_class_method
      assert_equal "object instance method", Foo.object_instance_method

      assert_raise NoMethodError do Foo.new.object_class_method end
      assert_equal "object instance method", Foo.new.object_instance_method
    end

    test "module method" do
      assert_raise NoMethodError do Foo.module_class_method end
      assert_equal "module instance method", Foo.module_instance_method

      assert_raise NoMethodError do Foo.new.module_class_method end
      assert_raise NoMethodError do Foo.new.module_instance_method end
    end

    test "class method" do
      assert_raise NoMethodError do Foo.class_class_method end
      assert_equal "class instance method", Foo.class_instance_method

      assert_raise NoMethodError do Foo.new.class_class_method end
      assert_raise NoMethodError do Foo.new.class_instance_method end
    end
  end
end
