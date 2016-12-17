#!/usr/bin/env ruby
require 'webrick'
require 'webrick/httpproxy'
include WEBrick

class OriginalHTTPProxyServer < HTTPProxyServer
  def proxy_service(req, res)
    localfile = "#{req.host}/#{req.path}"
    puts localfile
    if File.file?(localfile)
      res.body = open(localfile).read
      return
    end
    super
  end
end

s = OriginalHTTPProxyServer.new(Port: 8080)
trap("INT"){ s.shutdown }
s.start
