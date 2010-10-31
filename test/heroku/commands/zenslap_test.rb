require 'test_helper.rb'
require 'heroku'

class ZenslapTest < Test::Unit::TestCase

  context "add command" do
    ZENSLAP_ID = 1
    GITHUB_URL = "git@github.com:opsb/conference_hub"
    GITHUB_REPO_OWNER = "opsb"
    GITHUB_REPO_NAME = "conference_hub"
    GITHUB_LOGIN = "jimbo"
    GITHUB_TOKEN = "df67sd6f67"    
    
    setup do
      @git_repo = stub(
        :heroku_app => 'conference_hub',
        :github_url => GITHUB_URL,
        :github_credentials => { :login => GITHUB_LOGIN, :token => GITHUB_TOKEN },
        :owner => GITHUB_REPO_OWNER,
        :name => GITHUB_REPO_NAME
      )
      Repo.stubs(:new).returns(@git_repo)
      
      @zenslap_client = mock
      @zenslap_client.stubs( :add_service_hook )
      @zenslap_client.stubs( :configure )
      ZenslapClient.stubs(:new).returns(@zenslap_client)
      
      @github_client = mock
      GithubClient.stubs(:new).with( GITHUB_REPO_OWNER, GITHUB_REPO_NAME, { :login => GITHUB_LOGIN, :token => GITHUB_TOKEN } ).returns(@github_client)
      @github_client.stubs(:add_service_hook)
      @github_client.stubs(:add_collaborator)
      
      @command = Heroku::Command::Zenslap.new nil
      
      @heroku_client = mock
      @heroku_client.stubs( :install_addon )
      @heroku_client.stubs( :config_vars ).returns({ "ZENSLAP_ID" => ZENSLAP_ID })
      @command.stubs(:heroku).returns(@heroku_client)      
      

    end
    
    context "for user project" do
      setup do
        @github_client.stubs(:owner_type).returns(:user)
        @command.add        
      end
      
      should "install addon" do
        assert_received @heroku_client, :install_addon, &with( "conference_hub", "zenslap" )
      end

      should "configure zenslap with github_url" do
        assert_received @zenslap_client, :configure, &with( ZENSLAP_ID, GITHUB_REPO_OWNER, GITHUB_REPO_NAME )
      end

      should "add service hook to github" do
        assert_received @github_client, :add_service_hook, &with( "http://zenslap.me/pushes" )
      end      
      
      should "add zenslap access to github" do
        assert_received @github_client, :add_collaborator, &with( "zenslap" )
      end
      
      should "have checked user type" do
        assert_received @github_client, :owner_type
      end
    end
    
    context "for organisation project" do
      setup do
        @github_client.stubs(:owner_type).returns(:organization)
        @github_client.stubs(:collaborators_page).returns("https://github.com/opsb/zenslap/edit#collab_bucket")
        @command.stubs(:puts)
        @command.add        
      end
      
      should "display instructions for adding zenslap collaborator" do
        assert_received @github_client, :collaborators_page
        assert_received @command, :puts do |expect|
          expect.times(5)
        end
      end
    end

  end
  
end
