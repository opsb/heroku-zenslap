require 'heroku/command'
require 'heroku'

module Heroku::Command
  class Zenslap < Base
    ZENSLAP_HEROKU_USER = "admin@zenslap.me"
    ZENSLAP_ADDON = "zenslap2"

    def display_error(message)
      puts "---! #{message}"
    end

    def create
      begin
        puts "---> Creating test environment in heroku"
        heroku_app = heroku.create
        heroku.add_collaborator(heroku_app, ZENSLAP_HEROKU_USER)
        git_repo = Repo.new
        git_repo.add_zenslap_remote(heroku_app)
        repo_owner = git_repo.owner
        repo_name = git_repo.name
        github_credentials = git_repo.github_credentials

        puts "---> Installing zenslap addon"
        heroku.install_addon heroku_app, ZENSLAP_ADDON
        zenslap_client = ZenslapClient.new
        zenslap_id = heroku.config_vars(heroku_app)["ZENSLAP_ID"]

        puts "---> Configuring zenslap"
        zenslap_client.configure( zenslap_id, repo_owner, repo_name, github_credentials, heroku_app )

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

__END__
def plugin_available?
  heroku_client.addons.map{ |addon| addon["name"] }.find do |name| 
    name =~ /zenslap.*/
  end
end

def show_introduction
  puts "zenslap is the easiest way to add continuous integration to your heroku app. We're currently in alpha. You can go ahead and request an invitation@zenslap.me."
end
