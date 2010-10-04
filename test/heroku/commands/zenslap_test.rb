require 'test_helper.rb'
require 'heroku'

class ZenslapTest < Test::Unit::TestCase

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


    context "after adding zenslap service" do
      CALLBACK_URL = "http://zenslap.heroku.com/pushes"
      
      setup do     
        @repo_mock = stub(:add => CALLBACK_URL)
        
        Repository.stubs( :new ).returns( @repo_mock )
        RestClient.stubs(:put)
        @heroku_client.stubs(:install_addon)
        
        @command.add
      end

      should "have added zenslap addon" do
        assert_received @heroku_client, :install_addon, &with("conference_hub", "zenslap")
      end

      should "configured zenslap repository with github_url" do
        assert_received RestClient, :put, &with( 
          "http://zenslap.heroku.com/repositories/#{ZENSLAP_ID}", 
          {:repository => { :github_url => GITHUB_URL }} 
        )
      end

      should "add service hook to github" do
        assert_received @repo_mock, :add, &with(CALLBACK_URL)
      end
    end
  end

end