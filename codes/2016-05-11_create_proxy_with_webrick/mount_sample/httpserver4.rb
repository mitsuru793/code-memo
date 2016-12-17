#!/usr/bin/env ruby
require 'webrick'
include WEBrick

s = HTTPServer.new(
  Port: 8000
)
$docroot = File.join(Dir.pwd, "public_html")
s.mount_proc("/") do |req, res|
  res.body = open(File.join($docroot, *req.path.split("/"))).read
end

trap("INT"){ s.shutdown }
s.start
