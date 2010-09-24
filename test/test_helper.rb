require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'bourne'
require 'webmock/test_unit'

class Test::Unit::TestCase
  include WebMock
end

require 'lib/heroku/commands/zenslap.rb'

