require 'test_helper'

class GitTest < Test::Unit::TestCase
  context "repository" do
    HEROKU_URL= "git@heroku.com:conference_hub.git"
    GITHUB_URL = "git@github.com:opsb/conference_hub"
        
    setup do
      File.stubs(:open).with('./.git/config').returns(StringIO.new(HEROKU_URL + " " + GITHUB_URL))

      @git = Git.new
    end
    
    should "have heroku_url" do
      assert_equal @git.heroku_url, "git@heroku.com:conference_hub.git"
    end
  
    should "have heroku_app" do
      assert_equal @git.heroku_app, "conference_hub"
    end
    
    should "have github_credentials"
    should "have github_url"
  end
end