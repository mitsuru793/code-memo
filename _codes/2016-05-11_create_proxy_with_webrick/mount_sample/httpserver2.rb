#!/usr/bin/env ruby
require 'webrick'
include WEBrick

s = HTTPServer.new(
  Port: 8000,
  DocumentRoot: File.join(Dir.pwd, "public_html")
)
s.mount("/text", HTTPServlet::FileHandler, File.join(Dir.pwd, "public_text"))

trap("INT"){ s.shutdown }
s.start
