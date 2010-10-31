class ZenslapClient
  
  def configure(id, repo_owner, repo_name)
    RestClient.put("http://zenslap.me/heroku/resources/#{id}", {:project => {:owner => repo_owner, :name => repo_name}})
  end
  
end
