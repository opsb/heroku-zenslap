class ZenslapClient
  
  def self.configure(uuid, repo_owner, repo_name, github_credentials, heroku_app)
    #TODO need to make https
    RestClient.post("http://zenslap.me/projects", 
      {
        :project => github_credentials.merge({
                                              :owner => repo_owner, 
                                              :name => repo_name,
                                              :uuid => uuid,
                                              :heroku_app => heroku_app
                                             })
      }
    )
  end
  
end
