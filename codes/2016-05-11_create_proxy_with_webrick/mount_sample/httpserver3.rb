#!/usr/bin/env ruby
require 'webrick'
include WEBrick

s = HTTPServer.new(
  Port: 8000,
  DocumentRoot: File.join(Dir.pwd, "public_html")
)
s.mount_proc("/echo") do |req, res|
  res.body = "PATH: #{req.path}"
end

trap("INT"){ s.shutdown }
s.start
