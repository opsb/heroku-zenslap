require 'open-uri'
require 'net/https'

class GithubClient
  
  def initialize(git_url)
    @username, @repository = /git@github.com:(\w+)\/(\w+)/.match(git_url)[1..2]
  end
  
  def add_service_hook(service_hook)
    all_hooks = service_hooks + [service_hook]
    form_data = all_hooks.map{ |hook| "urls[]=#{hook}" }.join("&")
    service_hooks_url = "https://github.com/#{@username}/#{@repository}/edit/postreceive_urls?login=%s&token=%s" % [
      CONFIG['GITHUB_LOGIN'], CONFIG['GITHUB_TOKEN']
    ]
    post service_hooks_url, form_data
  end

  def service_hooks 
    html = open(
      "https://github.com/%s/%s/edit?login=%s&token=%s" % [
        @username, @repository, CONFIG['GITHUB_LOGIN'], CONFIG['GITHUB_TOKEN']
      ]
    ).read
    matches = html.scan(/<input.*?id="urls_".*?value="(http:\/\/[^"]+)"[^>]*?>/)
    matches
  end

  def add_collaborator(collaborator)
    uri = "https://github.com/api/v2/yaml/repos/collaborators/#{@repository}/add/#{collaborator}?login=%s&token=%s" % [
      CONFIG['GITHUB_LOGIN'], CONFIG['GITHUB_TOKEN']
    ]
    post( uri )
  end
  
  def post(url, payload = nil)
    uri = URI.parse(url)
    request = ::Net::HTTP::Post.new(uri.request_uri)
    https = ::Net::HTTP::Proxy('localhost', '8888').new(uri.host, uri.port) 
    https.use_ssl = true
    https.start do |https|
      response = https.request request, payload
      puts response.inspect
    end
  end

end

__END__

def add(service_hook)
  begin
    params = ["https://github.com/#{@username}/#{@repository}/edit/postreceive_urls", {
      "urls" => service_hooks + [service_hook], 
        "login" => CONFIG['GITHUB_LOGIN'],
        "token" => CONFIG['GITHUB_TOKEN']
    }]
    RestClient.post(*params)
  rescue RestClient::Exception => e
    e.response.net_http_res.code == '302'
  end
end