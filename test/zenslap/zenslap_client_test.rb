require 'spec_helper'
require 'net/http'
require 'uri'

describe ZenslapClient do
  
  context "zenslap client" do
    ZENSLAP_ID = 5
    OWNER = "opsb"
    NAME = "carbonpt"
    GITHUB_CREDENTIALS = { :login => 'jimbo', :token => 'randomhash'}
    HEROKU_EMAIL = "jim@bob.com"
    HEROKU_PASSWORD = "password"
    HEROKU_APP = "conference_hub_ci"
    
    before do
      RestClient.stubs(:post)      
    end
    
    it "should configure the project" do
      ZenslapClient.configure ZENSLAP_ID, OWNER, NAME, GITHUB_CREDENTIALS, HEROKU_APP
      RestClient.should have_received(:post).with( "http://zenslap.me/projects", :project => 
        GITHUB_CREDENTIALS.merge({ :owner => OWNER, :name => NAME, :uuid => ZENSLAP_ID, :heroku_app => HEROKU_APP } ))
    end

  end
end