def add_date_of_current_dir_to_front_matter(glob)
  Dir.glob(glob) do |path|
    date = Time.parse(get_date_str_of_current_dir(path))
    buff = File.read(path)
    last_delim_lineno = get_lineno(buff, /^---$/, 2)
    new_buff = add_line(buff, "date: #{date.to_s}", last_delim_lineno)
    File.write(path, new_buff)
  end
end

def get_date_str_of_current_dir(path)
  if File.ftype(path) == 'directory'
    current_dir_basename = File.basename(path)
  else
    current_dir_name = File.dirname(path)
    current_dir_basename = File.basename(current_dir_name)
  end
  current_dir_basename.match(/\d{4}-\d{2}-\d{2}/)[0]
end

def get_lineno(content, pattern, match_number)
  lineno = 0
  match_count = 0
  content.each_line do |line|
    lineno += 1
    match_count += 1 if line.match(pattern)
    if match_count == match_number
      return lineno
    end
  end
end

def add_line(content, string, lineno)
  new_lines = ''
  count_lineno = 0
  content.each_line do |line|
    count_lineno += 1
    new_lines += string + "\n" if count_lineno == lineno
    new_lines += line
  end
  new_lines
end
