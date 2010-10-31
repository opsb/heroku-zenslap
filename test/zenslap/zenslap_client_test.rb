require 'test_helper'
require 'net/http'
require 'uri'

class ZenslapClientTest < Test::Unit::TestCase
  
  context "zenslap client" do
    ZENSLAP_ID = 5
    OWNER = "opsb"
    NAME = "carbonpt"
    
    setup do
      @zenslap_client = ZenslapClient.new
    end
    
    should "configure the project" do
      stub_request(:put, "http://zenslap.me/heroku/resources/#{ZENSLAP_ID}").
                    with( { :body => {:project => {:owner => OWNER, :name => NAME}}} ).
                    to_return(:status => 200)
      @zenslap_client.configure ZENSLAP_ID, OWNER, NAME
    end

  end
end