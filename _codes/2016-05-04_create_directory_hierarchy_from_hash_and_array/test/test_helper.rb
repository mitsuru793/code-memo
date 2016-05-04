DIR_NAME = File.dirname(__FILE__)
Dir[File.join(DIR_NAME, "../lib/**/*.rb")].each { |f| require f }
require 'test/unit'
require 'test/unit/assertions'
require 'fileutils'
require 'fakefs'

def get_paths(glob)
  paths = []
  Dir.glob(glob) do |path|
    paths << path
  end
  paths
end

module Test::Unit::Assertions
  def assert_paths(expected, actual)
    assert_equal expected.size, actual.size
    expected.each_with_index do |value, i|
      e_path  = value[0]
      e_ftype = value[1].to_s
      a_path  = actual[i]
      a_ftype = File.ftype(actual[i])

      assert_equal e_path, a_path, "#{a_path} must be #{e_path}"
      assert_equal e_ftype, a_ftype, "A type of #{a_path} must be #{e_ftype}"
    end
  end
end
