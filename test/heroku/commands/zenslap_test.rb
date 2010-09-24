require 'test_helper.rb'

class ZenslapTest < Test::Unit::TestCase
  context "zenslap command" do
    setup do
      @command = Heroku::Command::Zenslap.new nil
      @command.stubs(:github_url).returns("git@github.com:opsb/zenslap-heroku")
      RestClient.stubs(:post).with("http://zenslap.heroku.com/heroku/resources", :github_url => "git@github.com:opsb/zenslap-heroku")
      @command.add      
    end
    should "provision continuous integration through zenslap API" do
      assert_received RestClient, :post do |expect| 
        expect.with "http://zenslap.heroku.com/heroku/resources", :github_url => "git@github.com:opsb/zenslap-heroku" 
      end
    end
  end
end