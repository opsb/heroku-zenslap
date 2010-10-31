class ZenslapClient
  
  def configure(id, repo_owner, repo_name, github_credentials)
    RestClient.put("http://zenslap.me/heroku/resources/#{id}", 
      {:project => github_credentials.merge({:owner => repo_owner, :name => repo_name})})
  end
  
end
