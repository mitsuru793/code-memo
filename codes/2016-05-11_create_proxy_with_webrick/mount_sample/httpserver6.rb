#!/usr/bin/env ruby
require 'webrick'
include WEBrick

s = HTTPServer.new(
  Port: 8000
)

$docroot = File.expand_path(File.join(Dir.pwd, "public_html"))

s.mount_proc("/") do |req, res|
  filename = File.expand_path(File.join($docroot, *req.path.split("/")))
  if File.directory?(filename)
    filename = File.join(filename, "index.html")
  end
  res.body = open(filename).read

  content_types = {
    "html" => "text/html",
    "txt"  => "text/plain",
    "jpg"  => "image/jpeg",
    "jpeg" => "image/jpeg",
    "gif"  => "image/gif",
    "png"  => "image/png"
  }
  content_type = content_types[File.extname(filename)]
  if content_type == nil
    content_type = "text/html"
  end
  res["Content-Type"] = content_type
end

trap("INT"){ s.shutdown }
s.start