#!/usr/bin/env ruby
require 'thor'
require_relative '../lib/my_app'

class Command < Thor
  desc 'hello', 'command for test'
  option :tmp_option, :aliases =>'-t', :type => :string
  def hello
    puts($stdin.eof? ? "no pipe" : $stdin.read)
  end

  desc 'say', 'command for test'
  option :tmp_option, :aliases =>'-t', :type => :string
  def say
    app = MyApp.new
    app.input = StringIO.new(options['tmp_option'])
    app.say
  end
end

Command.start(ARGV)
