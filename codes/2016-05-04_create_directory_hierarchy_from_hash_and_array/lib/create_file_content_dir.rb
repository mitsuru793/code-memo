require 'fileutils'

class CreateFileContentDir
  class << self
    def create_tree_with_content(tree)
      case tree
      when Hash # Dir or File
        tree.each do |name, value|
          case value
          when String # name is File
            File.write(name.to_s, value)
          when Array # name is Dir
            old_path = Dir.pwd
            mkdir_cd(name.to_s)
            create_tree_with_content(value)
            Dir.chdir(old_path)
          end
        end
      when Array # Dirs or Files
        tree.each do |dir_file|
          create_tree_with_content(dir_file)
        end
      when *[String, Symbol] # Empty File
        FileUtils.touch(tree.to_s)
      end
    end

    def mkdir_cd(path)
      mkdir(path)
      Dir.chdir(path)
    end

    def mkdir(path)
      FileUtils.mkdir_p(path)
    end
  end
end
