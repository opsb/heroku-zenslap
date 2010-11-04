class ZenslapClient
  
  def configure(id, repo_owner, repo_name, github_credentials, heroku_email, heroku_password)
    #TODO need to make https
    RestClient.put("http://zenslap.me/heroku/resources/#{id}", 
      {
        :project => github_credentials.merge({
                                              :owner => repo_owner, 
                                              :name => repo_name,
                                              :heroku_email => heroku_email,
                                              :heroku_password => heroku_password}
                                             )
      }
    )
  end
  
end
