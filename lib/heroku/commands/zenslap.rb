require 'heroku/command'
require 'heroku'

module Heroku::Command
  class Zenslap < Base

    def display_error(message)
      puts "---! #{message}"
    end

    def add
      begin
        git_repo = Repo.new
        github_url = git_repo.github_url
        repo_owner = git_repo.owner
        repo_name = git_repo.name
        heroku_app = git_repo.heroku_app
        github_credentials = git_repo.github_credentials

        puts "---> Installing zenslap addon"
        heroku.install_addon heroku_app, "zenslap2"
        zenslap_client = ZenslapClient.new
        zenslap_id = heroku.config_vars(heroku_app)["ZENSLAP_ID"]

        puts "---> Configuring zenslap"
        zenslap_client.configure( zenslap_id, repo_owner, repo_name, github_credentials, heroku.user, heroku.password )
        github_client = GithubClient.new( repo_owner, repo_name, github_credentials )

        puts "---> Adding github service hook"
        github_client.add_service_hook "http://zenslap.me/pushes"

        case github_client.owner_type
        when :user
          puts "---> Adding zenslap as github collaborator"
          github_client.add_collaborator( "zenslap" )
          puts "---> zenslap added"
        when :organization
          puts "---> zenslap added"
          puts "---> Nearly there, you just need to add zenslap as a collaborator on #{github_client.collaborators_page}"
        end

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
