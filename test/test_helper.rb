require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :test)
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'bourne'
require 'webmock/test_unit'
require 'ruby-debug'

class Test::Unit::TestCase
  include WebMock
end

require 'lib/zenslap/console_error.rb'
require 'lib/zenslap/zenslap_client.rb'
require 'lib/zenslap/github_client.rb'
require 'lib/zenslap/repo.rb'
require 'lib/heroku/commands/zenslap'
require 'lib/heroku/commands/zenslap.rb'
require 'test/object_graph.rb'

def with(*args)
  Proc.new do |expect|
    expect.with *args
  end
end

#Uncomment if you wish to see the requests and responses
# WebMock.after_request do |request_signature, response|
#   puts "Request #{request_signature} was made and #{response} was returned"
# end
