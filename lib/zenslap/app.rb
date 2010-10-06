require 'heroku'
require 'heroku/command'

module Zenslap
  module Heroku 
    class App
      attr_accessor :name
      
      def initialize(name)
        @name = name
      end
      
      def add_zenslap
        heroku_client.install_addon name, "zenslap"
      end
      
      def heroku_client
        ::Heroku::Client.new *credentials
      end

      def credentials
        ::Heroku::Command::Auth.new(nil).get_credentials
      end      
    end
  end
end