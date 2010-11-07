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
      RestClient.stubs(:post)      
      @zenslap_client = ZenslapClient.new
    end
    
    should "configure the project" do
      @zenslap_client.configure ZENSLAP_ID, OWNER, NAME, GITHUB_CREDENTIALS, HEROKU_EMAIL, HEROKU_PASSWORD
      assert_received RestClient, :post do |expect|
        expect.with( "http://zenslap.me/projects", 
                      :project => GITHUB_CREDENTIALS.merge(
                                    { 
                                      :owner => OWNER, 
                                      :name => NAME, 
                                      :heroku_email => HEROKU_EMAIL, 
                                      :heroku_password => HEROKU_PASSWORD, 
                                      :uuid => ZENSLAP_ID 
                                    }
                                  )
                   )
      end
    end

  end
end