require 'fileutils'

module DirHelper
  @@dir_re = %r{/$}

  def mkdir_cd(path)
    if mkdir?(path)
      Dir.chdir(path)
    else
      raise StandardError.new("failed to make a directory: #{path}.")
    end
  end

  def mkdir?(path)
    if dir_name?(path)
      FileUtils.mkdir_p(trim_dir_re(path))
      true
    else
      false
    end
  end

  def dir_name?(path)
    path.match(@@dir_re) ? true : false
  end

  def trim_dir_re(dir_path)
    dir_path.gsub(@@dir_re, '')
  end

  def dir_re=(val)
    @@dir_re=val
  end
end
