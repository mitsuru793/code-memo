require 'awesome_print'
require 'fileutils'
require_relative 'dir_helper'

class CreateFileDir
  extend DirHelper
  def self.create_tree(tree)
    tree = tree.to_s if tree.is_a?(Symbol)
    case tree
    when Hash # Dir
      tree.each do |dir_name, dirs_files|
        raise "#{dir_name} must has a Array." unless dirs_files.is_a?(Array)
        dir_name = dir_name.to_s if dir_name.is_a?(Symbol)
        raise "#{dir_name} must match  #{@@dir_re}" unless dir_name?(dir_name)
        old_path = Dir.pwd
        mkdir_cd(dir_name)
        create_tree(dirs_files)
        Dir.chdir(old_path)
      end
    when Array # Dirs or Files
      tree.each do |dir_file|
        create_tree(dir_file)
      end
    when String # File
      dir_name?(tree) ? mkdir?(tree) : FileUtils.touch(tree)
    end
  end
end
