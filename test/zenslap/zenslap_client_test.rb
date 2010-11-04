require 'test_helper'
require 'net/http'
require 'uri'

class ZenslapClientTest < Test::Unit::TestCase
  
  context "zenslap client" do
    ZENSLAP_ID = 5
    OWNER = "opsb"
    NAME = "carbonpt"
    GITHUB_CREDENTIALS = { :login => 'jimbo', :token => 'randomhash'}
    HEROKU_EMAIL = "jim@bob.com"
    HEROKU_PASSWORD = "password"
    
    setup do
      @zenslap_client = ZenslapClient.new
    end
    
    should "configure the project" do
      stub_request(:put, "http://zenslap.me/heroku/resources/#{ZENSLAP_ID}").
                    with( { :body => {:project => GITHUB_CREDENTIALS.merge({:owner => OWNER, :name => NAME, :heroku_email => HEROKU_EMAIL, :heroku_password => HEROKU_PASSWORD})}} ).
                    to_return(:status => 200)
      @zenslap_client.configure ZENSLAP_ID, OWNER, NAME, GITHUB_CREDENTIALS, HEROKU_EMAIL, HEROKU_PASSWORD
    end

  end
end