require 'test_helper'

class GitTest < Test::Unit::TestCase
  context "repository" do
    HEROKU_URL= "git@heroku.com:conference_hub.git"
    GITHUB_URL = "git@github.com:opsb/conference_hub"
    GITHUB_USER = "jimbo"
    GITHUB_TOKEN = "df67sd6f67"
        
    setup do
      File.stubs(:open).with('./.git/config').returns(StringIO.new(HEROKU_URL + " " + GITHUB_URL))
      @git = Git.new
    end
    
    should "have heroku_url" do
      assert_equal @git.heroku_url, HEROKU_URL
    end
  
    should "have heroku_app" do
      assert_equal @git.heroku_app, "conference_hub"
    end

    should "have github_url" do
      assert_equal @git.github_url, GITHUB_URL
    end
    
    context "with stored github.user" do
      setup do
        @git.stubs(:exec).with("git config --get github.user").returns(GITHUB_USER + "\n")
        @git.stubs(:exec).with("git config --get github.token").returns(GITHUB_TOKEN + "\n")        
      end
      
      should "have github_credentials" do  
        assert_equal @git.github_credentials, {:login => GITHUB_USER, :token => GITHUB_TOKEN}
      end
    end
    
    context "missing github credentials" do
      setup do
        @git.stubs(:exec).with("git config --get github.user").returns("")
        @git.stubs(:exec).with("git config --get github.token").returns("")

        @git.stubs(:ask_for).with("your github user").returns(GITHUB_USER)
        @git.stubs(:ask_for).with("your github token").returns(GITHUB_TOKEN)
        
        @git.stubs(:exec).with("git config --add github.user #{GITHUB_USER}")
        @git.stubs(:exec).with("git config --add github.token #{GITHUB_TOKEN}")        
        
        @git.github_credentials
      end
      
      should "have asked for a github user" do
        assert_received @git, :ask_for, &with("your github user")
      end
      
      should "have asked for a github token" do
        assert_received @git, :ask_for, &with("your github token")        
      end
    end
    
    context "missing github address" do
      should "show error" do
        @git.stubs(:git_config).returns("nothing")
        assert_raise RuntimeError do
          @git.github_url
        end
      end
    end

  end
end