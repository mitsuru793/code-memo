#!/usr/bin/env ruby

IP       = '0.0.0.0'
PORT     = '8080'
DOC      = './'
CGI_PATH = '/usr/bin/env ruby'

require 'webrick'
opts = {
  BindAddress:    IP,
  Port:           PORT,
  DocumentRoot:   DOC,
  CGIInterpreter: CGI_PATH
}

server = WEBrick::HTTPServer.new(opts)

server.mount('/view.cgi', WEBrick::HTTPServlet::CGIHandler, 'view.rb')

Signal.trap(:INT){ server.shutdown }

server.start
