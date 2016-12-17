#!/usr/bin/env ruby
require 'webrick'
require 'webrick/httpproxy'
include WEBrick

class OriginalHTTPProxyServer < HTTPProxyServer
  def proxy_service(req, res)
    if %r{\.2ch\.net$}.match(req.host)
      res.body = 'blocked'
      res.header['content-type'] = 'text/plain'
      return
    end
    super
  end
end

s = OriginalHTTPProxyServer.new(Port: 8080)
trap("INT"){ s.shutdown }
s.start
