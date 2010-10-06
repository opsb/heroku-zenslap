require 'rubygems'
require 'httparty'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'bourne'
require 'webmock/test_unit'
require 'nokogiri'
require 'json'

class Test::Unit::TestCase
  include WebMock
end

require 'lib/config.rb'
require 'lib/heroku/commands/zenslap.rb'
require 'lib/zenslap/repository.rb'
require 'lib/zenslap/app.rb'

def with(*args)
  Proc.new do |expect|
    expect.with *args
  end
end