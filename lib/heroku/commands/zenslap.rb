require 'heroku/command'
require 'heroku'

module Heroku::Command
  class Zenslap < Base
    ZENSLAP_HEROKU_USER = "admin@zenslap.me"
    ZENSLAP_ADDON = "zenslap2"

    def display_error(message)
      puts "---! #{message}"
    end

    def git
      @git_repo ||= Repo.new
    end

    def create
      begin
        puts "---> Creating test environment in heroku"
        heroku_app = heroku.create
        heroku.add_collaborator(heroku_app, ZENSLAP_HEROKU_USER)
        git.add_zenslap_remote(heroku_app)

        puts "---> Installing zenslap addon"
        heroku.install_addon heroku_app, ZENSLAP_ADDON
        zenslap_id = heroku.config_vars(heroku_app)["ZENSLAP_ID"]

        puts "---> Configuring zenslap"
        ZenslapClient.configure( zenslap_id, git.owner, git.name, git.github_credentials, heroku_app )

      rescue ConsoleError => e
        display_error e
      end
      
      def destroy
        puts "---> Destroying zenslap project and test environment"
        heroku_app = Repo.new.zenslap_app
        heroku.destroy heroku_app
      rescue ConsoleError => e
        display_error e
      end
    end
  end
end
