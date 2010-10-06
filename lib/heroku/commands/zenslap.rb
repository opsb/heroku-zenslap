require 'heroku/command'
require 'heroku'
require 'git'
require 'zenslap/zenslap_client.rb'
require 'zenslap/github_client.rb'
require 'config.rb'

module Heroku::Command
  class Zenslap < Base
    HEROKU_GIT_REGEX = /git@heroku.com:(.*)\.git/
    GITHUB_REGEX = /github.com:\w+\/\w+/

    def add
      git_repo = Git.open(".")
      git_urls = git_repo.remotes.map{ |r| r.url }
      heroku_url = git_urls.find{ |git_url| git_url =~ HEROKU_GIT_REGEX }
      heroku_app = heroku_url[HEROKU_GIT_REGEX, 1]
      heroku_credentials = Heroku::Command::Auth.new(nil).get_credentials
      heroku_client = Heroku::Client.new heroku_credentials
      heroku_client.install_addon heroku_app, "zenslap"
      zenslap_client = ZenslapClient.new
      zenslap_id = heroku_client.config_vars(heroku_app)["ZENSLAP_ID"]
      github_url = git_urls.find{ |git_url| git_url =~ GITHUB_REGEX }
      zenslap_client.configure( zenslap_id, { :github_url => github_url } )
      github_client = GithubClient.new
      github_client.add_service_hook github_url, "http://zenslap.me/pushes"
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
