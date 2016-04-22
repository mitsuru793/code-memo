require 'test_helper'

class HogeTest < Test::Unit::TestCase
  def setup
    @md_string = <<-EOF
---
title: hello world
---
hello, hello!
    EOF
  end

  test "extend" do
    parsed = FrontMatterParser.parse(@md_string)
    assert_true parsed.kind_of?(FrontMatterParser::Parsed)
    assert_equal parsed.extend_hello, "extend hello"
    assert_equal parsed.module_hello, "module hello"

    assert_raise NameError do Extend::FrontMatterParser end
    assert_raise NoMethodError do parsed.refine_hello end
    assert_raise NoMethodError do parsed.instance_hello end

    parsed.extend(InstanceExtend)
    assert_equal parsed.instance_hello, "instance hello"
  end
end
