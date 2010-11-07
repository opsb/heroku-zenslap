class ZenslapClient
  
  def configure(uuid, repo_owner, repo_name, github_credentials, heroku_email, heroku_password)
    #TODO need to make https
    RestClient.post("http://zenslap.me/projects", 
      {
        :project => github_credentials.merge({
                                              :owner => repo_owner, 
                                              :name => repo_name,
                                              :heroku_email => heroku_email,
                                              :heroku_password => heroku_password,
                                              :uuid => uuid
                                             })
      }
    )
  end
  
end
