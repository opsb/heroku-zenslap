require 'test_helper.rb'

class ZenslapTest < Test::Unit::TestCase
  context "zenslap command" do
    setup do
      @command = Heroku::Command::Zenslap.new nil
    end
    should "show branches" do
      @command.add
    end
  end
end