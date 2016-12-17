#!/usr/bin/env ruby
require 'webrick'
require 'webrick/httpproxy'
include WEBrick

handler = Proc.new do |req, res|
  if res['content-type'] =~ %r{^text/html}
    puts true
    res.body.gsub!(/think/, "THINK")
  end
end

s = WEBrick::HTTPProxyServer.new(Port: 8080, ProxyContentHandler: handler)
trap("INT"){ s.shutdown }
s.start
