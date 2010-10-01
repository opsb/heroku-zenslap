require 'test_helper.rb'

class ZenslapTest < Test::Unit::TestCase
  
  context "zenslap add command" do
    
    CALLBACK_URL = "http://zenslap.heroku.com/pushes"
    REPO_GIT_URL = "git@github.com:opsb/zenslap-heroku"
    REPO_HTTP_URL = "http://zenslap.heroku.com/heroku/resources"
    
    setup do
      @repo_mock = mock      
      Repository.stubs( :new ).returns( @repo_mock )
      @repo_mock.expects( :add ).with( CALLBACK_URL )
      
      @command = Heroku::Command::Zenslap.new nil
      @command.stubs( :github_url ).returns( REPO_GIT_URL )
      RestClient.stubs( :post ).with( REPO_HTTP_URL, :github_url => REPO_GIT_URL )
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