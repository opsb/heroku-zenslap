require 'heroku/command'
require 'heroku'
require 'zenslap/zenslap_client.rb'
require 'zenslap/github_client.rb'
require 'config.rb'

module Heroku::Command
  class Zenslap < Base
    HEROKU_GIT_REGEX = /git@heroku.com:(.*)\.git/
    GITHUB_REGEX = /git@github.com:.+?\b\/.+?\b/

    def add
      heroku_app = heroku_url[HEROKU_GIT_REGEX, 1]
      heroku_credentials = Heroku::Command::Auth.new(nil).get_credentials
      heroku_client = Heroku::Client.new heroku_credentials
      heroku_client.install_addon heroku_app, "zenslap"
      zenslap_client = ZenslapClient.new
      zenslap_id = heroku_client.config_vars(heroku_app)["ZENSLAP_ID"]
      zenslap_client.configure( zenslap_id, { :github_url => github_url } )
      github_client = GithubClient.new
      github_client.add_service_hook github_url, "http://zenslap.me/pushes"
      github_client.add_collaborator( "zenslap" )
    end
    
    def github_url
      git_config[GITHUB_REGEX]
    end
    
    def heroku_url
      git_config[HEROKU_GIT_REGEX]
    end
    
    def git_config
      @git_config ||= File.open('./.git/config').read
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
