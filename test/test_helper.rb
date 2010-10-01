require 'rubygems'
require 'httparty'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'bourne'
require 'webmock/test_unit'
require 'nokogiri'

class Test::Unit::TestCase
  include WebMock
end

require 'lib/heroku/commands/zenslap.rb'
require 'lib/zenslap/repository.rb'