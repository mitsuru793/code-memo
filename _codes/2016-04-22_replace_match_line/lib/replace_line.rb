def replace_nth(lines, pattern, replacement, match_number)
  match_count = 0
  new_lines = ''
  lines.each_line do |line|
    match_count += 1 if line.match(pattern)
    line.gsub!(pattern, replacement) if match_count == match_number
    new_lines += line
  end
  new_lines
end
