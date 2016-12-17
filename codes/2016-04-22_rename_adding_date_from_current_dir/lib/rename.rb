def rename_adding_date_from_current_dir(glob)
  Dir.glob(glob) do |path|
    current_dir_name = File.dirname(path)
    current_dir_basename = File.basename(current_dir_name)
    date_str = current_dir_basename.match(/\d{4}-\d{2}-\d{2}/)[0]
    new_file_name = date_str + '_' + File.basename(path)
    File.rename(path, File.join(current_dir_name, new_file_name))
  end
end
