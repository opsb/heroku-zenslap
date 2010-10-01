require 'httparty'

class Repository
  include HTTParty
  
  def initialize(url, auth)
    @url = url
    @auth = auth
  end
  
  def service_hooks
    html = Repository.get("http://github.com/opsb/zenslap/edit?login=#{@auth[:login]}&token=#{@auth[:token]}")
    doc = Nokogiri::HTML(html)
    (doc/"input[name='urls[]']/@value").to_a.map{ |value| value.to_s }
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