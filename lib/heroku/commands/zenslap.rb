require 'heroku/command'
require 'heroku'
require 'zenslap/zenslap_client.rb'
require 'zenslap/github_client.rb'
require 'zenslap/git.rb'

module Heroku::Command
  class Zenslap < Base

    def add
      git_repo = Git.new
      heroku_credentials = Heroku::Command::Auth.new(nil).get_credentials
      heroku_client = Heroku::Client.new heroku_credentials
      heroku_client.install_addon git_repo.heroku_app, "zenslap"
      zenslap_client = ZenslapClient.new
      zenslap_id = heroku_client.config_vars(git_repo.heroku_app)["ZENSLAP_ID"]
      zenslap_client.configure( zenslap_id, { :github_url => git_repo.github_url } )
      github_client = GithubClient.new( git_repo.github_url, git_repo.github_credentials )
      github_client.add_service_hook git_repo.github_url, "http://zenslap.me/pushes"
      github_client.add_collaborator( "zenslap" )
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
