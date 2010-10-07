class ZenslapClient
  
  def configure(id, github_url)
    put "http://zenslap.me/heroku/resources/#{id}", as_form_data( github_url )
  end
  
  def as_form_data(github_url)
    username, name = /git@github.com:(\w+)\/(\w+)/.match(github_url)[1..2]
    "repository[username]=#{username}&repository[name]=#{name}"
  end
  
  def put(url, payload)
    uri = URI.parse(url)
    request = ::Net::HTTP::Put.new(uri.request_uri)
    ::Net::HTTP.start(uri.host, uri.port) do |http|
      response = http.request request, payload
    end
  end
end