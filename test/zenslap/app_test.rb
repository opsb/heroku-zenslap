require 'test_helper'

module Zenslap
  module Heroku
    class AppTest < Test::Unit::TestCase

      context "a zenslap client" do

        APP_NAME = "conference_hub"
        HEROKU_USER = "zenslap"

        setup do
          @app = Zenslap::Heroku::App.new("conference_hub")
          @heroku_client = stub(:install_addon => nil)        
          @app.stubs( :heroku_client ).returns( @heroku_client )        
        end

        should "add zenslap addon" do
          @app.add_zenslap
          assert_received @heroku_client, :install_addon do |expect|
            expect.with APP_NAME, HEROKU_USER
          end
        end

      end

    end
  end
end