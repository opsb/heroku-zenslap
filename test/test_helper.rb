require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'bourne'
require 'webmock/test_unit'

class Test::Unit::TestCase
  include WebMock
end

require 'lib/config.rb'
require 'lib/heroku/commands/zenslap.rb'

def with(*args)
  Proc.new do |expect|
    expect.with *args
  end
end