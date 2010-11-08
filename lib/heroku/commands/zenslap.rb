require 'heroku/command'
require 'heroku'

module Heroku::Command
  class Zenslap < Base
    ZENSLAP_HEROKU_USER = "admin@zenslap.me"
    ZENSLAP_ADDON = "zenslap2"

    def display(message)
      puts "---> #{message}"
    end

    def display_error(message)
      puts "---! #{message}"
    end
    
    def display_numbered_bullets(items)
      items.each_with_index do |item, index|
        puts "  #{index}) #{item}"
      end
    end

    def git_repo
      @git_repo ||= GitRepo.new
    end

    def create
      begin
        if git_repo.remote_exists? 'zenslap'
          display_error "Zenslap has already been set up"
          return
        end
        
        display "Creating test environment in heroku"
        heroku_app = heroku.create
        heroku.add_collaborator(heroku_app, ZENSLAP_HEROKU_USER)
        git_repo.add_zenslap_remote(heroku_app)

        display "Installing zenslap addon"
        heroku.install_addon heroku_app, ZENSLAP_ADDON
        zenslap_id = heroku.config_vars(heroku_app)["ZENSLAP_ID"]

        display "Configuring zenslap"
        ZenslapClient.configure( zenslap_id, git_repo.github_owner, git_repo.github_name, git_repo.github_credentials, heroku_app )
        
        display "Nearly there, you just need to do add a couple of things on github"
        display_numbered_bullets [
          "Add 'zenslap' as a collaborator",
          "Add 'http://zenslap.me/pushes' to the service hooks"
        ]
        display "Once you've done that you'll be ready to go"

      rescue ConsoleError => e
        display_error e
      end
      
      def destroy
        display "Destroying zenslap project and test environment"
        heroku.destroy git_repo.zenslap_app
        display "All done. Thanks for using zenslap."
      rescue ConsoleError => e
        display_error e
      end
    end
  end
end
