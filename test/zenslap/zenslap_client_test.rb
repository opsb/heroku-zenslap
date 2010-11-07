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
    HEROKU_APP = "conference_hub_ci"
    
    setup do
      RestClient.stubs(:post)      
    end
    
    should "configure the project" do
      ZenslapClient.configure ZENSLAP_ID, OWNER, NAME, GITHUB_CREDENTIALS, HEROKU_APP
      assert_received RestClient, :post do |expect|
        expect.with( "http://zenslap.me/projects", :project => 
          GITHUB_CREDENTIALS.merge({ :owner => OWNER, :name => NAME, :uuid => ZENSLAP_ID, :heroku_app => HEROKU_APP } ))
      end
    end

  end
end