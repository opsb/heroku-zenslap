require 'spec_helper'

module GitRepoSpec

  describe GitRepo do
    def stub_git
      @git = stub(
      :remotes => [
        stub( :name => "origin", :url => GITHUB_URL)
        ],
        :add_remote => nil,
        :config => nil
        )

        Git.stubs(:open).returns(@git)      
      end  

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

        before do
          stub_git
          @git_repo = GitRepo.new
        end

        it "should have github owner" do
          assert_equal @git_repo.github_owner, "opsb"
        end

        it "should have github name" do
          assert_equal @git_repo.github_name, "conference_hub"
        end

        it "should have github_url" do
          assert_equal @git_repo.github_url, GITHUB_URL
        end

        it "should add zenslap remote" do
          @git_repo.add_zenslap_remote(HEROKU_APP)
          @git.should have_received(:add_remote).with(HEROKU_APP, HEROKU_URL)
        end

        VALID_GITHUB_URLS.each do |url|    
          it "should accept valid github url #{url}" do
            git_repo = stub(:remotes => [stub(:url => url)])
            Git.stubs(:open).returns(git_repo)
            assert_equal @git_repo.github_url, url
          end
        end

        INVALID_GITHUB_URLS.each do |url|    
          it "should not accept invalid github url #{url}" do
            git_repo = stub(:remotes => [stub(:url => url)])
            Git.stubs(:open).returns(git_repo)        
            lambda {
              @git_repo.github_url          
              }.should raise_error(ConsoleError)
            end
          end

          context "with zenslap remote" do
            it "should have zenslap app" do
              @git.stubs(:remote).with("zenslap").returns(stub( :name => "zenslap", :url => ZENSLAP_GIT_REPO))        
              assert_equal @git_repo.zenslap_app, ZENSLAP_APP
            end
          end

          context "with stored github.user" do
            before do
              @git_repo.stubs(:exec).with("git config --get github.user").returns(GITHUB_USER + "\n")
              @git_repo.stubs(:exec).with("git config --get github.token").returns(GITHUB_TOKEN + "\n")        
            end

            it "should have github_credentials" do  
              assert_equal @git_repo.github_credentials, {:login => GITHUB_USER, :token => GITHUB_TOKEN}
            end
          end

          context "missing github credentials" do
            before do
              @git_repo.stubs(:exec).with("git config --get github.user").returns("")
              @git_repo.stubs(:exec).with("git config --get github.token").returns("")

              @git_repo.stubs(:ask_for).with("your github user").returns(GITHUB_USER)
              @git_repo.stubs(:ask_for).with("your github token").returns(GITHUB_TOKEN)

              @git_repo.stubs(:exec).with("git config --add github.user #{GITHUB_USER}")
              @git_repo.stubs(:exec).with("git config --add github.token #{GITHUB_TOKEN}")        

              @git_repo.github_credentials
            end

            it "should have asked for a github user" do
              assert_received @git_repo, :ask_for, &with("your github user")
            end

            it "should have asked for a github token" do
              assert_received @git_repo, :ask_for, &with("your github token")        
            end
          end

          context "missing github address" do
            it "should show error" do
              Git.stubs( :open ).returns( stub( :remotes => [] ) )
              assert_raise ConsoleError do
                @git_repo.github_url
              end
            end
          end

        end
      end

    end