require 'test_helper.rb'
require 'heroku'

class ZenslapTest < Test::Unit::TestCase

  should "detect plugin is available" do
    @command = Heroku::Command::Zenslap.new nil
    Heroku::Client.any_instance.stubs(:addons).returns([{"name" => "zenslap:test"}])    
    assert @command.plugin_available?
  end

  should "detect plugin is not available" do
    @command = Heroku::Command::Zenslap.new nil
    Heroku::Client.any_instance.stubs(:addons).returns([{"name" => "memcached"}])    
    assert !@command.plugin_available?
  end

  context "zenslap command" do
    GITHUB_URL = "git@github.com:opsb/conference_hub"
    HEROKU_URL = "git@heroku.com:conference_hub.git"
    ZENSLAP_ID = "10"

    setup do
      @heroku_client = mock
      @command = Heroku::Command::Zenslap.new nil

      Heroku::Client.stubs(:new).returns(@heroku_client)
      @heroku_client.stubs(:config_vars).returns({ "ZENSLAP_ID" => ZENSLAP_ID })
      @command.stubs(:git_urls).returns([GITHUB_URL, HEROKU_URL])
      @command.stubs(:credentials).returns(["jim@bo.com", "password"])
    end

    should "find github url" do
      assert_equal GITHUB_URL, @command.github_url
    end

    should "find heroku url" do
      assert_equal HEROKU_URL, @command.heroku_url
    end

    should "find heroku app name" do
      assert_equal "conference_hub", @command.heroku_app_name
    end

    should "retrieve ZENSLAP_ID" do
      assert_equal ZENSLAP_ID, @command.zenslap_id
    end
    
    should "retrieve heroku test url" do
      WebMock.allow_net_connect!
      response = RestClient.get "http://zenslap.heroku.com/heroku/resources/4.json"
      WebMock.disable_net_connect!
      assert_equal JSON.parse(response.body)["heroku_url"], "git@heroku.com:strong-rain-37.git"
    end

    context "after adding zenslap service" do
      CALLBACK_URL = "http://zenslap.heroku.com/pushes"
      HEROKU_TEST_URL = "git@heroku.com:warm-sky-56.git"

      setup do     
        @repo_mock = stub(:add => CALLBACK_URL)
        @git_repo = stub(:add_remote)

        Git.stubs(:open).returns(@git_repo)
        @command.stubs(:heroku_test_url).returns(HEROKU_TEST_URL)

        Repository.stubs( :new ).returns( @repo_mock )
        RestClient.stubs(:put)
        @heroku_client.stubs(:install_addon)

      end

      context "plugin unavailable" do
        setup do
          @command.stubs(:plugin_available?).returns(false)
          @command.stubs(:show_introduction)
          @command.add
        end

        should "show introduction and instructions for applying to alpha programme" do
          assert_received @command, :show_introduction
        end
      end

      context "plugin available" do  
        setup do
          @command.stubs(:plugin_available?).returns(true)        
          @command.add
        end

        should "have added zenslap addon" do
          assert_received @heroku_client, :install_addon, &with("conference_hub", "zenslap")
        end

        should "configured zenslap repository with github_url" do
          assert_received RestClient, :put, &with( 
          "http://zenslap.heroku.com/heroku/resources/#{ZENSLAP_ID}", 
          {:repository => { :github_url => GITHUB_URL }} 
          )
        end

        should "add service hook to github" do
          assert_received @repo_mock, :add, &with(CALLBACK_URL)
        end

        should "add heroku test app to git config" do
          assert_received @git_repo, :add_remote do |expect|
            expect.with("test", HEROKU_TEST_URL)
          end
        end  
      end

    end

  end
end
