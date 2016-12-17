require_relative 'test_helper'

class DirHelperTest < Test::Unit::TestCase
  include DirHelper
  def setup
    FileUtils.rm(Dir.glob('*'))
  end

  sub_test_case "mkdir_cd" do
    data(
      'base name' => ['dir1/'],
      'root' => ['/'],
      'path 1' => ['dir1/dir2/'],
      'path 2' => ['/dir1/dir2/']
    )
    test "making and cd are success" do |data|
      path = data[0]
      mkdir_cd(path)
      expected = File.join('/', path.chomp('/'))
      assert_equal expected, Dir.pwd
    end

    data(
      'base name' => ['dir1_name'],
      'empty string' => [''],
      'path 1' => ['dir1/dir2_name'],
      'path 2' => ['/dir1/dir2_name']
    )
    test "making and cd are failed" do |data|
      path = data[0]
      expected = StandardError.new("failed to make a directory: #{path}.")
      assert_raise expected do mkdir_cd(path) end
    end
  end

  sub_test_case "mkdir" do
    data(
      'base name' => ['dir1/'],
      'root' => ['/'],
      'path 1' => ['dir1/dir2/'],
      'path 2' => ['/dir1/dir2/']
    )
    test "making is success" do |data|
      path = data[0]
      assert_true mkdir?(path), 'mkdir'
      assert_true File.exists?(path), 'exists'
    end

    data(
      'base name' => ['dir1_name'],
      'empty string' => [''],
      'path 1' => ['dir1/dir2_name'],
      'path 2' => ['/dir1/dir2_name']
    )
    test "making is failed" do |data|
      path = data[0]
      assert_false mkdir?(path), 'mkdir'
      assert_false File.exists?(path), 'exists' unless path.empty?
    end
  end

  sub_test_case "dir_name?" do
    data(
      'base name' => ['dir1/'],
      'root' => ['/'],
      'path 1' => ['dir1/dir2/'],
      'path 2' => ['/dir1/dir2/']
    )
    test "returns true" do |data|
      path = data[0]
      assert_true dir_name?(path)
    end

    data(
      'base name' => ['dir1_name'],
      'empty string' => [''],
      'path 1' => ['dir1/dir2_name'],
      'path 2' => ['/dir1/dir2_name']
    )
    test "returns false" do |data|
      path = data[0]
      assert_false dir_name?(path)
    end
  end

  data(
    'trim'    => ['dir1',  'dir1/'],
    'no trim' => ['file1', 'file1']
  )
  test "trim_dir_re" do |data|
    expected, path = data
    assert_equal expected, trim_dir_re(path)
  end
end
