require 'heroku/command'
require 'git'
require 'nokogiri'
require 'rest_client'
require 'zenslap/repository.rb'
require 'config.rb'

module Heroku::Command
  class Zenslap < Base
    def add
      puts "---> Adding zenslap"
      puts "---> Creating test environment"
      RestClient.post "http://zenslap.heroku.com/heroku/resources", :github_url => github_url
      puts "---> Test environment created"
      puts "---> Adding github service hook"
      Repository.new(github_url).add("http://zenslap.heroku.com/pushes")
      puts "---> Added service hook"
      puts "---> Zenslap is ready. Your next push to github will be tested and you will be emailed the results."
    end
    
    private
    def github_url
      git_urls.find{ |url| url =~ /git@github.com:.*/} || (raise "No github address found")
    end
    
    def git_urls
      git_repo.remotes.map{ |r| r.url }
    end
    
    def git_repo
      Git.open '.'
    end
  end
end