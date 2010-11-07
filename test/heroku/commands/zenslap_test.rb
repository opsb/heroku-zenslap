require 'spec_helper.rb'
require 'heroku'

module ZenslapSpec

  describe Heroku::Command::Zenslap do
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
        stubs(:github_owner).returns(GITHUB_REPO_OWNER)
        stubs(:github_name).returns(GITHUB_REPO_NAME)
        stubs(:add_zenslap_remote)
        stubs(:zenslap_app).returns(HEROKU_APP)
      end
      GitRepo.stubs(:new).returns(@git_repo)
    end

    def stub_zenslap
      ZenslapClient.stubs(:configure)
    end

    def stub_heroku
      @heroku = stub do
        stubs(:user).returns(HEROKU_EMAIL)
        stubs(:password).returns(HEROKU_PASSWORD)
        stubs(:create).returns(HEROKU_APP)
        stubs(:add_collaborator)
        stubs(:install_addon)
        stubs(:config_vars).returns({ "ZENSLAP_ID" => ZENSLAP_ID })
        stubs(:destroy)      
      end
      @command.stubs(:heroku).returns(@heroku)      
    end

    context "zenslap" do
      before do
        @command = Heroku::Command::Zenslap.new nil      
        stub_git
        stub_zenslap
        stub_heroku    
      end

      context "#create" do

        before do
          @command.create
        end

        it "should create new heroku app to be used for running tests and billing" do
          assert_received @heroku, :create
        end      

        it "should add zenslap remote" do
          assert_received @git_repo, :add_zenslap_remote, &with( HEROKU_APP )
        end

        it "should add zenslap as a collaborator to heroku app" do
          assert_received @heroku, :add_collaborator, &with( HEROKU_APP, "admin@zenslap.me" )
        end

        it "should install addon" do
          assert_received @heroku, :install_addon, &with( "conference_hub", ADDON_NAME )
        end

        it "should configure zenslap with github and heroku details" do
          assert_received ZenslapClient, :configure, 
          &with( ZENSLAP_ID, GITHUB_REPO_OWNER, GITHUB_REPO_NAME, GITHUB_CREDENTIALS, HEROKU_APP )
        end

      end

      context "#destroy" do
        before do
          @command.destroy
        end

        it "should destroy heroku app" do
          assert_received @heroku, :destroy, &with(HEROKU_APP)
        end
      end
    end  
  end
end