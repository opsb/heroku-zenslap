require 'test_helper'

class RepoTest < Test::Unit::TestCase
  context "repository" do
    HEROKU_URL= "git@heroku.com:conference_hub.git"
    GITHUB_URL = "git@github.com:opsb/conference_hub"
    GITHUB_USER = "jimbo"
    GITHUB_TOKEN = "df67sd6f67"
    
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
      
    INVALID_HEROKU_URLS = [
      "git@herodku.com:conference_hub.git",
      "git@heroku.com/conference_hub.git",
      "git@heroku.com:conference_hub.pit"
    ]

    VALID_HEROKU_URLS = [
        "git@heroku.com:conference_hub.git",
        "git@heroku.com:confe--ence_hub.git",
        "git@heroku.com:confer2ence_hub.git",
        "git@heroku.com:c.onfe.rence_hub.git",
        "git@heroku.zenslap:conferencehub-production.git"
      ]
        
    setup do
      File.stubs(:open).with('./.git/config').returns(StringIO.new(HEROKU_URL + " " + GITHUB_URL))
      Git.stubs(:open).returns(
        graph({ :remotes => 
          [ { :name => "origin", :url => "git@github.com:opsb/conference_hub" },
            { :name => "heroku", :url => "git@heroku.com:conference_hub.git" } ] 
        })
      )
      @repo = Repo.new
    end
    
    should "have heroku_url" do
      assert_equal @repo.heroku_url, HEROKU_URL
    end
  
    should "have heroku_app" do
      assert_equal @repo.heroku_app, "conference_hub"
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
    
    VALID_HEROKU_URLS.each do |url|    
      should "accept valid github url #{url}" do
        git_repo = stub(:remotes => [stub(:url => url)])
        Git.stubs(:open).returns(git_repo)
        assert_equal @repo.heroku_url, url
      end
    end
    
    INVALID_HEROKU_URLS.each do |url|    
      should "not accept invalid github url #{url}" do
        assert_raises ConsoleError do
          git_repo = stub(:remotes => [stub(:url => url)])
          Git.stubs(:open).returns(git_repo)
          @repo.heroku_url
        end
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
    
    context "with multiple heroku addresses" do
      PRODUCTION_URL = "git@heroku.zenslap:conferencehub-production.git"
      STAGE_URL = "git@heroku.com:conferencehub-stage.git"
      
      setup do
        Git.stubs(:open).returns(
          graph({ :remotes => 
            [ { :name => "production", :url => PRODUCTION_URL },
              { :name => "stage", :url => STAGE_URL } ] 
          })
        )
      end
      
      should "ask user to choose a remote for heroku_url" do
        @repo.stubs(:puts)
        @repo.stubs(:gets).returns("production\n")
        assert_equal @repo.heroku_url, PRODUCTION_URL
        assert_received @repo, :puts do |expect|
          expect.with %w{production stage}
        end
      end
    end

  end
end