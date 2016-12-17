require 'test/unit'
require 'fileutils'
require 'awesome_print'
require 'fakefs'
require_relative '../lib/rename'

class RenameTest < Test::Unit::TestCase
  def setup
    FileUtils.rm(Dir.glob('*'))
    @dir_names = %w{2016-04-01_hello 2016-04-02_world}
    @dir_names.each do |dir_name|
      Dir.mkdir(dir_name)
      file_path = File.join('/', dir_name, 'README.md')
      File.write(file_path, '')
    end
  end

  sub_test_case "Dir.glob" do
    setup do
      under_dir_name = File.join(@dir_names[0], 'under')
      Dir.mkdir(under_dir_name)
      @file_path = File.join('/', under_dir_name, 'README.md')
      File.write(@file_path, '')
    end

    test "recursive" do
      paths = []
      assert_true File.exists?(@file_path)
      Dir.glob('./**/README.md') do |path|
        paths << path
      end
      assert_not_empty paths.grep(@file_path)
    end

    test "not recursive" do
      paths = []
      assert_true File.exists?(@file_path)
      Dir.glob('./*/README.md') do |path|
        paths << path
      end
      assert_empty paths.grep(@file_path)
    end
  end

  test "rename_adding_date_from_current_dir" do
    rename_adding_date_from_current_dir('./*/README.md')
    paths = []
    Dir.glob('./**/*README.md') do |path|
      paths << path
    end

    assert_equal File.basename(paths[0]), '2016-04-01_README.md'
    assert_equal File.basename(paths[1]), '2016-04-02_README.md'
  end
end
