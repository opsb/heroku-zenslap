require 'httparty'

class Repository
  include HTTParty
  
  def initialize(url)
    @username, @repository = /git@github.com:(\w+)\/(\w+)/.match(url)[1..2]
  end
  
  def service_hooks
    doc = Nokogiri::HTML(
      Repository.get(
        "http://github.com/%s/%s/edit?login=%s&token=%s" % [
          @username,
          @repository,
          CONFIG['GITHUB_LOGIN'],
          CONFIG['GITHUB_TOKEN']
        ]
      )
    )
    (doc/"input[name='urls[]']/@value").to_a.map &:to_s
  end
  
  def add(service_hook)
    begin
      RestClient.post(
        "https://github.com/#{@username}/#{@repository}/edit/postreceive_urls", {
        "urls" => service_hooks + [service_hook], 
        :login => CONFIG['GITHUB_LOGIN'],
        :token => CONFIG['GITHUB_TOKEN']
      })
    rescue Exception => e
      raise e unless e.response.net_http_res.code == '302'
    end
  end
  
end