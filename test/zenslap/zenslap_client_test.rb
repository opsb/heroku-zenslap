require 'test_helper'
require 'net/http'
require 'uri'

class ZenslapClientTest < Test::Unit::TestCase
  
  context "zenslap client" do
    ZENSLAP_ID = 5
    USERNAME = "opsb"
    NAME = "carbonpt"
    GITHUB_URL = "git@github.com:#{USERNAME}/#{NAME}"
    
    setup do
      @zenslap_client = ZenslapClient.new
    end
    
    should "configure github url" do
      stub_request(:put, "http://zenslap.me/heroku/resources/#{ZENSLAP_ID}").
                    with( { :body => "repository[username]=#{USERNAME}&repository[name]=#{NAME}" } )

      @zenslap_client.configure ZENSLAP_ID, GITHUB_URL
    end

  end
end