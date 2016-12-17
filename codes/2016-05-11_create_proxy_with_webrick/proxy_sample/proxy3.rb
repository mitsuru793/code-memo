#!/usr/bin/env ruby
require 'webrick'
require 'webrick/httpproxy'
include WEBrick

class OriginalHTTPProxyServer < HTTPProxyServer
  def proxy_service(req, res)
    super
    if res['content-type'] =~ %r{^text/html}
      res.body.gsub!(/think/, "THINK")
    end
  end
end

s = OriginalHTTPProxyServer.new(Port: 8080)
trap("INT"){ s.shutdown }
s.start
