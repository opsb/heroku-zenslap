require 'test_helper.rb'
require 'heroku'

class ZenslapTest < Test::Unit::TestCase

  context "add command" do
    ZENSLAP_ID = 1
    HEROKU_URL= "git@heroku.com:conference_hub.git"
    GITHUB_URL = "git@github.com:opsb/conference_hub"
    
    setup do
      @heroku_client = mock
      @heroku_client.stubs( :install_addon )
      @heroku_client.stubs( :config_vars ).returns({ "ZENSLAP_ID" => ZENSLAP_ID })
      Heroku::Client.stubs(:new).returns(@heroku_client)
      
      github_remote = Struct.new(:url).new(GITHUB_URL)
      heroku_remote = Struct.new(:url).new(HEROKU_URL)
      @git_repo = stub( :remotes => [ github_remote, heroku_remote ] )
      Git.stubs(:open).returns(@git_repo)
      
      @zenslap_client = mock
      @zenslap_client.stubs( :add_service_hook )
      @zenslap_client.stubs( :configure )
      ZenslapClient.stubs(:new).returns(@zenslap_client)
      
      @github_client = mock
      GithubClient.stubs(:new).returns(@github_client)
      @github_client.stubs(:add_service_hook)
      @github_client.stubs(:add_collaborator)
      
      @command = Heroku::Command::Zenslap.new nil
      
      @command.add
    end
    
    should "install addon" do
      assert_received @heroku_client, :install_addon, &with( "conference_hub", "zenslap" )
    end
    
    should "configure zenslap with github_url" do
      assert_received @zenslap_client, :configure, &with( ZENSLAP_ID, { :github_url => GITHUB_URL } )
    end
    
    should "add service hook to github" do
      assert_received @github_client, :add_service_hook, &with( GITHUB_URL, "http://zenslap.me/pushes" )
    end
    
    should "add zenslap access to github" do
      assert_received @github_client, :add_collaborator, &with( "zenslap" )
    end

  end
  
end
