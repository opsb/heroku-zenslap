require 'heroku/command'
require 'heroku'
require 'git'
require 'nokogiri'
require 'rest_client'
require 'zenslap/repository.rb'
require 'zenslap/app.rb'
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
    end

    # def add
    #   puts "---> Checking availability"
    #   if plugin_available?
    #     provision_plugin
    #   else
    #     show_introduction
    #   end
    # end
    # 
    # def plugin_available?
    #   heroku_client.addons.map{ |addon| addon["name"] }.find do |name| 
    #     name =~ /zenslap.*/
    #   end
    # end    
    # 
    # def show_introduction
    #   puts "zenslap is the easiest way to add continuous integration to your heroku app. We're currently in alpha. You can go ahead and request an invitation@zenslap.me."
    # end    
    # 
    # def provision_plugin
    #   heroku_client.install_addon heroku_app, "zenslap"
    #   zenslap_id = heroku_client.config_vars(heroku_app)["ZENSLAP_ID"]
    #   zenslap_client.configure zenslap_id, { :github_url => github_url }
    #   # ---> github_client.add_service_hook "http://zenslap.me/pushes"
    #   # ---> github_client.add_collaborator "zenslap"
    #   # ---> heroku_client.add_collaborator heroku_test_app, "admin@zenslap.me"
    #   
    #   
    #   
    # 
    # 
    #   puts "---> Configuring for #{github_url}"
    #   RestClient.put "http://zenslap.me/heroku/resources/#{zenslap_id}", :repository => { :github_url => github_url }
    # 
    #   puts "---> Adding service hooks to github"
    #   repo = Repository.new(github_url)
    #   repo.add("http://zenslap.me/pushes")
    # 
    #   puts "---> Adding zenslap access to #{github_url}"
    #   repo.add_github_access
    #   
    #   puts "---> Adding zenslap access to test environment"
    #   heroku_client.add_collaborator heroku_test_app_name, "admin@zenslap.me"
    # 
    #   puts "---> Zenslap is ready. Your next push to github will be tested and you will be emailed the results."
    # end    
    # 
    # def heroku_test_app_name
    #   heroku_test_url[HEROKU_GIT_REGEX, 1]
    # end
    # 
    # def heroku_test_url
    #   response = RestClient.get "http://zenslap.me/heroku/resources/#{zenslap_id}.json"
    #   JSON.parse( response.body )["heroku_url"]    
    # end
    # 
    # def heroku_app
    #   heroku_url[HEROKU_GIT_REGEX, 1]
    # end
    # 
    # def heroku_url
    #   git_urls.find{ |url| url =~ HEROKU_GIT_REGEX }            
    # end
    # 
    # def github_url
    #   git_urls.find{ |url| url =~ /git@github.com:.*/} || (raise "No github address found")
    # end
    # 
    # def git_urls
    #   git_repo.remotes.map{ |r| r.url }
    # end
    # 
    # 
    # private
    # def git_repo
    #   Git.open '.'
    # end
    # 
    # def heroku_client
    #   Heroku::Client.new *credentials
    # end
    # 
    # def credentials
    #   Heroku::Command::Auth.new(nil).get_credentials
    # end
  end
end
