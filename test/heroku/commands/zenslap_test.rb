require 'test_helper.rb'
require 'heroku'

class ZenslapTest < Test::Unit::TestCase
  ZENSLAP_ID = 1
  GITHUB_URL = "git@github.com:opsb/conference_hub"
  GITHUB_REPO_OWNER = "opsb"
  GITHUB_REPO_NAME = "conference_hub"
  GITHUB_LOGIN = "jimbo"
  GITHUB_TOKEN = "df67sd6f67"
  GITHUB_CREDENTIALS = { :login => GITHUB_LOGIN, :token => GITHUB_TOKEN }  
  HEROKU_EMAIL = "jim@bob.com"
  HEROKU_PASSWORD = "password"
  HEROKU_APP = "conference_hub"
  ADDON_NAME = "zenslap2"

  def stub_git
    @git_repo = stub do
      stubs(:github_url).returns(GITHUB_URL)
      stubs(:github_credentials).returns(GITHUB_CREDENTIALS)
      stubs(:owner).returns(GITHUB_REPO_OWNER)
      stubs(:name).returns(GITHUB_REPO_NAME)
      stubs(:add_zenslap_remote)
      stubs(:zenslap_app).returns(HEROKU_APP)
    end
    Repo.stubs(:new).returns(@git_repo)
  end

  def stub_zenslap
    @zenslap_client = mock do
      stubs( :add_service_hook )
      stubs( :configure )       
    end
    ZenslapClient.stubs(:new).returns(@zenslap_client)
  end

  def stub_heroku
    @heroku = stub do
      stubs(:user).returns(HEROKU_EMAIL)
      stubs(:password).returns(HEROKU_PASSWORD)
      stubs(:create).returns(HEROKU_APP)
      stubs(:add_collaborator)
      stubs(:install_addon)
      stubs(:config_vars).returns({ "ZENSLAP_ID" => ZENSLAP_ID })
      stubs(:uninstall_addon)
      stubs(:destroy)      
    end
    @command.stubs(:heroku).returns(@heroku)      
  end

  context "zenslap" do
    setup do
      @command = Heroku::Command::Zenslap.new nil      
      stub_git
      stub_zenslap
      stub_heroku    
    end

    context "#create" do

      setup do
        @command.create
      end

      should "create new heroku app to be used for running tests and billing" do
        assert_received @heroku, :create
      end      

      should "add zenslap remote" do
        assert_received @git_repo, :add_zenslap_remote, &with( HEROKU_APP )
      end

      should "add zenslap as a collaborator to heroku app" do
        assert_received @heroku, :add_collaborator, &with( HEROKU_APP, "admin@zenslap.me" )
      end

      should "install addon" do
        assert_received @heroku, :install_addon, &with( "conference_hub", ADDON_NAME )
      end

      should "configure zenslap with github and heroku details" do
        assert_received @zenslap_client, :configure, 
        &with( ZENSLAP_ID, GITHUB_REPO_OWNER, GITHUB_REPO_NAME, GITHUB_CREDENTIALS, HEROKU_APP )
      end

    end

    context "#destroy" do
      setup do
        @command.destroy
      end

      should "remove addon" do
        assert_received @heroku, :uninstall_addon, &with(HEROKU_APP, ADDON_NAME)
      end

      should "destroy heroku app" do
        assert_received @heroku, :destroy, &with(HEROKU_APP)
      end
    end
  end  
end
