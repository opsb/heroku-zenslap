require 'httparty'

class Repository
  include HTTParty
  
  def initialize(url)
    @url = url
  end
  
  def service_hooks
    html = Repository.get("http://github.com/opsb/zenslap/edit?login=#{CONFIG['GITHUB_LOGIN']}&token=#{CONFIG['GITHUB_TOKEN']}")
    doc = Nokogiri::HTML(html)
    (doc/"input[name='urls[]']/@value").to_a.map{ |value| value.to_s }
  end
  
  def add(service_hook)
    RestClient.post("https://github.com/opsb/zenslap/edit/postreceive_urls", {
      "urls" => service_hooks + [service_hook], 
      :login => CONFIG['GITHUB_LOGIN'],
      :token => CONFIG['GITHUB_TOKEN']
    })
  end
  
  private
  GITHUB_URL_REGEX = /git@github.com:(\w+)\/(\w+)/
  
  def username
    @url[GITHUB_URL_REGEX, 1]
  end
  
  def name
    @url[GITHUB_URL_REGEX, 2]    
  end
  
end