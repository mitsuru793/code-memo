#!/usr/bin/env ruby
require 'webrick'
require 'webrick/httpproxy'
include WEBrick

class OriginalHTTPProxyServer < HTTPProxyServer
  def proxy_service(req, res)
    localfile = "#{req.host}/#{req.path}"
    if File.file?(localfile)
      res.body = open(localfile).read
      res.header["Content-Type"] = WEBrick::HTTPUtils.mime_type(req.path_info, WEBrick::HTTPUtils::DefaultMimeTypes)
      return
    end
    super
  end
end

s = OriginalHTTPProxyServer.new(Port: 8080)
trap("INT"){ s.shutdown }
s.start
