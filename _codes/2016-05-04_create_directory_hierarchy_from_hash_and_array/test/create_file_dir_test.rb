require_relative 'test_helper'

class CreateFileDirTest < Test::Unit::TestCase
  def setup
    FileUtils.rm(Dir.glob('*'))
  end

  test "create file with string or symbol" do
    tree = [
      '/file1',
      'file2',
      :file3
  ]
    CreateFileDir.create_tree(tree)
    paths = get_paths('**/*')
    expected =  [
      ['/file1', :file],
      ['/file2', :file],
      ['/file3', :file]
    ]
    assert_paths expected, paths
  end

  test "create dir with string or symbol" do
    tree = [
      {'dir1/' => [
        :file1
      ]},
      {'dir2/' => []},
      'dir3/'
    ]
    CreateFileDir.create_tree(tree)
    paths = get_paths('**/*')
    expected = [
      ['/dir1', :directory],
      ['/dir1/file1', :file],
      ['/dir2', :directory],
      ['/dir3', :directory]
    ]
    assert_paths expected, paths
  end

  test "dir must has a Array" do
    tree = [
      {dir1: 'file1'}
    ]
    expected = RuntimeError.new("dir1 must has a Array.")
    assert_raise expected do CreateFileDir.create_tree(tree) end
  end

  test "dir hash must has a Array" do
    tree = [
      {dir1: 'file1'}
    ]
    expected = RuntimeError.new("dir1 must has a Array.")
    assert_raise expected do CreateFileDir.create_tree(tree) end
  end
end
