require_relative 'test_helper'

class CreateFileContentDirTest < Test::Unit::TestCase
  def setup
    FileUtils.rm(Dir.glob('*'))
  end

  test "create file with string or symbol" do
    tree = [
      'file1',
      :file2
    ]
    CreateFileContentDir.create_tree_with_content(tree)
    paths = get_paths('**/*')
    assert_equal paths, ['/file1', '/file2']
  end


  test "create file with content when value of hash is String" do
    tree = [
      {file1: 'This is file1.'},
      {'file2' => 'This is file2.'}
    ]
    CreateFileContentDir.create_tree_with_content(tree)
    paths = get_paths('**/*')
    assert_equal paths, ['/file1', '/file2']
    assert_equal File.read(paths[0]), 'This is file1.'
    assert_equal File.read(paths[1]), 'This is file2.'
  end

  test "create dir with string or symbol" do
    tree = [
      {dir1: [
        :file1
      ]},
      {'dir2' => []}
    ]
    CreateFileContentDir.create_tree_with_content(tree)
    paths = get_paths('**/*')
    assert_equal paths, ['/dir1', '/dir1/file1', '/dir2']
  end
end
