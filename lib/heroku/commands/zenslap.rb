require 'heroku/command'
require 'heroku'

module Heroku::Command
  class Zenslap < Base
    ZENSLAP_HEROKU_USER = "admin@zenslap.me"
    ZENSLAP_ADDON = "zenslap2"

    def display_error(message)
      puts "---! #{message}"
    end

    def git_repo
      @git_repo ||= GitRepo.new
    end

    def create
      begin
        puts "---> Creating test environment in heroku"
        heroku_app = heroku.create
        heroku.add_collaborator(heroku_app, ZENSLAP_HEROKU_USER)
        git_repo.add_zenslap_remote(heroku_app)

        puts "---> Installing zenslap addon"
        heroku.install_addon heroku_app, ZENSLAP_ADDON
        zenslap_id = heroku.config_vars(heroku_app)["ZENSLAP_ID"]

        puts "---> Configuring zenslap"
        ZenslapClient.configure( zenslap_id, git_repo.github_owner, git_repo.github_name, git_repo.github_credentials, heroku_app )
        
        puts "---> You're all set up. Next time you push to github everything will get tested."

      rescue ConsoleError => e
        display_error e
      end
      
      def destroy
        puts "---> Destroying zenslap project and test environment"
        heroku.destroy git_repo.zenslap_app
        puts "---> All done. Thanks for using zenslap."
      rescue ConsoleError => e
        display_error e
      end
    end
  end
end
