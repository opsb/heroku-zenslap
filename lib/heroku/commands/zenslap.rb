require 'heroku/command'
require 'git'
require 'rest_client'

module Heroku::Command
  class Zenslap < Base
    def add
      RestClient.post "http://zenslap.heroku.com/heroku/resources", :github_url => github_url
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