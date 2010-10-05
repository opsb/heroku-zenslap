require 'heroku/command'
require 'heroku'
require 'git'
require 'nokogiri'
require 'rest_client'
require 'zenslap/repository.rb'
require 'config.rb'

module Heroku::Command
  class Zenslap < Base
    HEROKU_GIT_REGEX = /git@heroku.com:(.*)\.git/

    def add
      puts "---> Checking availability"
      if plugin_available?
        provision_plugin
      else
        show_introduction
      end
    end

    def plugin_available?
      client = Heroku::Client.new ENV['GITHUB_LOGIN'], ENV['GITHUB_TOKEN']
      client.addons.map{ |addon| addon["name"] }.include? "zenslap"      
    end    

    def show_introduction
      puts "zenslap is the easiest way to add continuous integration to your heroku app. We're currently in alpha. You can go ahead and request an invitation@zenslap.me."
    end    

    def provision_plugin
      puts "---> Adding zenslap addon to #{heroku_app_name}"
      heroku_client.install_addon heroku_app_name, "zenslap"

      puts "---> Configuring for #{github_url}"
      RestClient.put "http://zenslap.heroku.com/heroku/resources/#{zenslap_id}", :repository => { :github_url => github_url }

      puts "---> Adding service hooks to github"
      Repository.new(github_url).add("http://zenslap.heroku.com/pushes")

      puts "---> Adding test remote to local git config"
      git_repo.add_remote "test", heroku_test_url

      puts "---> Zenslap is ready. Your next push to github will be tested and you will be emailed the results."
    end    

    def heroku_app_name
      heroku_url[HEROKU_GIT_REGEX, 1]
    end

    def heroku_url
      git_urls.find{ |url| url =~ HEROKU_GIT_REGEX }            
    end

    def github_url
      git_urls.find{ |url| url =~ /git@github.com:.*/} || (raise "No github address found")
    end

    def git_urls
      git_repo.remotes.map{ |r| r.url }
    end

    def zenslap_id
      heroku_client.config_vars(heroku_app_name)["ZENSLAP_ID"]
    end

    private
    def git_repo
      Git.open '.'
    end

    def heroku_client
      Heroku::Client.new ENV["ZENSLAP_HEROKU_EMAIL"], ENV["ZENSLAP_HEROKU_PASSWORD"]
    end

  end
end