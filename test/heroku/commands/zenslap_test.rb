require 'test_helper.rb'

class ZenslapTest < Test::Unit::TestCase
  context "zenslap command" do
    setup do
      @command = Heroku::Command::Zenslap.new nil
    end
    should "provision continuous integration through zenslap API" do
      @command.expects(:github_url).returns("git@github.com:opsb/zenslap-heroku")
      @command.add
    end
  end
end