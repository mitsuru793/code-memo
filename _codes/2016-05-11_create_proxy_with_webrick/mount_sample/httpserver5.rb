#!/usr/bin/env ruby
require 'webrick'
include WEBrick

s = HTTPServer.new(
  Port: 8000
)

# File.expand_pathを使わなくても問題はなかった
#$docroot = File.join(Dir.pwd, "public_html")
$docroot = File.expand_path(File.join(Dir.pwd, "public_html"))

s.mount_proc("/") do |req, res|
  filename = File.expand_path(File.join($docroot, *req.path.split("/")))
  if File.directory?(filename)
    filename = File.join(filename, "index.html")
  end
  res.body = open(filename).read
end

trap("INT"){ s.shutdown }
s.start
