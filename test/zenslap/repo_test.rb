require 'test_helper'

class RepoTest < Test::Unit::TestCase
  context "repository" do
    HEROKU_URL= "git@heroku.com:conference_hub.git"
    GITHUB_URL = "git@github.com:opsb/conference_hub"
    GITHUB_USER = "jimbo"
    GITHUB_TOKEN = "df67sd6f67"
    HEROKU_APP = "conference_hub"
    ZENSLAP_ID = "abc"
    ZENSLAP_APP = "conference_hub_ci"
    ZENSLAP_GIT_REPO = "git@heroku.com:#{ZENSLAP_APP}.git"
    
    INVALID_GITHUB_URLS = [
      "git@invalidhub.com:opsb/conference_hub.git",
      "https://opsb@github.com/opsbconference_hub.git",
      "http://github.com.git"
    ]
    
    VALID_GITHUB_URLS = [
        "git@github.com:opsb/conference_hub.git",
        "https://opsb@github.com/opsb/conference_hub.git",
        "http://github.com/bblim-ke/we-bmo-ck.git",
        "http://github.com/bblim-ke/we.bmo.ck.git"
      ]
        
    setup do
      File.stubs(:open).with('./.git/config').returns(StringIO.new(HEROKU_URL + " " + GITHUB_URL))
      @git_repo = stub(
        :remotes => [
          stub( :name => "origin", :url => GITHUB_URL)
        ],
        :add_remote => nil,
        :config => nil
      )
      
      Git.stubs(:open).returns(@git_repo)
      @repo = Repo.new
    end
    
    should "have github owner" do
      assert_equal @repo.owner, "opsb"
    end
    
    should "have github name" do
      assert_equal @repo.name, "conference_hub"
    end

    should "have github_url" do
      assert_equal @repo.github_url, GITHUB_URL
    end
    
    should "add zenslap remote" do
      @repo.add_zenslap_remote(HEROKU_APP)
      assert_received @git_repo, :add_remote, &with(HEROKU_APP, HEROKU_URL)
    end
    
    should "add zenslap id to zenslap remote" do
      @repo.add_zenslap_id_to_zenslap_remote(ZENSLAP_ID)
      assert_received @git_repo, :config, &with("remote.zenslap.zenslap-id", ZENSLAP_ID)
    end
    
    VALID_GITHUB_URLS.each do |url|    
      should "accept valid github url #{url}" do
        git_repo = stub(:remotes => [stub(:url => url)])
        Git.stubs(:open).returns(git_repo)
        assert_equal @repo.github_url, url
      end
    end
    
    INVALID_GITHUB_URLS.each do |url|    
      should "not accept invalid github url #{url}" do
        assert_raises ConsoleError do
          git_repo = stub(:remotes => [stub(:url => url)])
          Git.stubs(:open).returns(git_repo)
          @repo.github_url
        end
      end
    end
    
    context "with zenslap remote" do
      should "have zenslap app" do
        @git_repo.stubs(:remote).with("zenslap").returns(stub( :name => "zenslap", :url => ZENSLAP_GIT_REPO))        
        assert_equal @repo.zenslap_app, ZENSLAP_APP
      end
    end

    context "with stored github.user" do
      setup do
        @repo.stubs(:exec).with("git config --get github.user").returns(GITHUB_USER + "\n")
        @repo.stubs(:exec).with("git config --get github.token").returns(GITHUB_TOKEN + "\n")        
      end
      
      should "have github_credentials" do  
        assert_equal @repo.github_credentials, {:login => GITHUB_USER, :token => GITHUB_TOKEN}
      end
    end
    
    context "missing github credentials" do
      setup do
        @repo.stubs(:exec).with("git config --get github.user").returns("")
        @repo.stubs(:exec).with("git config --get github.token").returns("")

        @repo.stubs(:ask_for).with("your github user").returns(GITHUB_USER)
        @repo.stubs(:ask_for).with("your github token").returns(GITHUB_TOKEN)
        
        @repo.stubs(:exec).with("git config --add github.user #{GITHUB_USER}")
        @repo.stubs(:exec).with("git config --add github.token #{GITHUB_TOKEN}")        
        
        @repo.github_credentials
      end
      
      should "have asked for a github user" do
        assert_received @repo, :ask_for, &with("your github user")
      end
      
      should "have asked for a github token" do
        assert_received @repo, :ask_for, &with("your github token")        
      end
    end
    
    context "missing github address" do
      should "show error" do
        Git.stubs( :open ).returns( stub( :remotes => [] ) )
        assert_raise ConsoleError do
          @repo.github_url
        end
      end
    end

  end
end