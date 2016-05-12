#!/usr/bin/env ruby
require 'time'

def add_date_of_current_dir_to_front_matter(glob)
  Dir.glob(glob) do |path|
    date = Time.parse(get_date_str_of_current_dir(path))
    buff = File.read(path)
    last_delim_lineno = get_lineno(buff, /^---$/, 2)

    is_set_date = false
    do_head_lines(buff, last_delim_lineno) do |line|
      case line
      when /^date: [^:\s]+/
        is_set_date = true
        line
      when /^date[:\s]+/
        line.replace('')
      end
      line
    end

    unless is_set_date
      new_buff = add_line(buff, "date: #{date.to_s}", last_delim_lineno)
      File.write(path, new_buff)
    end
  end
end

def do_head_lines(content, until_lineno, &block)
  lineno = 0
  new_content = []
  content.each_line do |line|
    lineno += 1
    new_content << (lineno > until_lineno ? line : yield(line))
  end
  content.replace(new_content.join)
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

path = File.join(ARGV[0], '*', 'README.md')
add_date_of_current_dir_to_front_matter(path)
