Bundler.require(:test)
require 'test/unit'
require 'shoulda'
require 'rspec'
require 'mocha'
require 'bourne'
require 'ruby-debug'

require File.dirname(__FILE__) + '/../lib/heroku_zenslap.rb'


RSpec.configure do |config|
  config.mock_with :mocha
  config.include Test::Unit::Assertions
end

def with(*args)
  Proc.new do |expect|
    expect.with *args
  end
end

#Uncomment if you wish to see the requests and responses
# WebMock.after_request do |request_signature, response|
#   puts "Request #{request_signature} was made and #{response} was returned"
# end

def show_invocations
  puts
  puts "Invocations"
  puts "==========="
  puts
  Mocha::Mockery.instance.invocations.each do |invocation|
    puts("#{invocation.mock.inspect}.#{invocation.method_name}( %s )\n\n" % [
      invocation.arguments.map(&:inspect).join(", ")
    ])
  end
end

