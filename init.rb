require 'rubygems'
require 'bundler/setup'
require File.dirname(__FILE__) + '/lib/zenslap/zenslap_client.rb'
require File.dirname(__FILE__) + '/lib/zenslap/github_client.rb'
require File.dirname(__FILE__) + '/lib/zenslap/git.rb'
require File.dirname(__FILE__) + '/lib/heroku/commands/zenslap'


Heroku::Command::Help.group('zenslap') do |group|
  group.command 'add', 'adds continuous integration to your project'
end