require 'test_helper.rb'
require 'heroku'

class ZenslapTest < Test::Unit::TestCase
  
  should "detect plugin is available" do
    @command = Heroku::Command::Zenslap.new nil
    Heroku::Client.any_instance.stubs(:addons).returns([{"name" => "zenslap"}])    
    assert @command.plugin_available?
  end
  
  should "detect plugin is not available" do
    @command = Heroku::Command::Zenslap.new nil
    Heroku::Client.any_instance.stubs(:addons).returns([{"name" => "memcached"}])    
    assert !@command.plugin_available?
  end
  
  context "zenslap add command" do
    
    CALLBACK_URL = "http://zenslap.heroku.com/pushes"
    REPO_GIT_URL = "git@github.com:opsb/zenslap-heroku"
    REPO_HTTP_URL = "http://zenslap.heroku.com/heroku/resources"
    
    setup do
      @repo_mock = mock      
      Repository.stubs( :new ).returns( @repo_mock )
      @repo_mock.stubs( :add ).with( CALLBACK_URL )
      
      @command = Heroku::Command::Zenslap.new nil
      @command.stubs( :github_url ).returns( REPO_GIT_URL )
      RestClient.stubs( :post ).with( REPO_HTTP_URL, :github_url => REPO_GIT_URL )
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
      
      should "provision continuous integration through zenslap API" do
        assert_received( RestClient, :post ) do |expect| 
          expect.with( REPO_HTTP_URL, :github_url => REPO_GIT_URL )
        end
      end
    
      should "add service hook to github" do
        assert_received @repo_mock, :add do |expect|
          expect.with CALLBACK_URL
        end
      end
    end
    
  end
  
end