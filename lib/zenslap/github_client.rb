require 'open-uri'
require 'net/https'
require 'set'
require 'octopussy'

class GithubClient
  
  def initialize(git_url, auth)
    @username, @repository = /git@github.com:(\w+)\/(\w+)/.match(git_url)[1..2]
    @auth = auth
  end
  
  def add_service_hook(service_hook)
    all_hooks = (service_hooks + [service_hook]).uniq
    form_data = all_hooks.map{ |hook| "urls[]=#{hook}" }.join("&")
    service_hooks_url = "https://github.com/#{@username}/#{@repository}/edit/postreceive_urls?login=%s&token=%s" % [
      @auth[:login], @auth[:token]
    ]
    post service_hooks_url, form_data
  end
  
  def add_team
    params = { :team => {:name => "zenslap", :permission => "pull"}, :login => @auth[:login], :token => @auth[:token]}
    RestClient.post("https://github.com/organizations/#{@username}/teams/create", params) do |response, request, result, &block|
      case response.code
      when 302
        response
      else
        response.return!(request, result, &block)
      end
    end
  end

  def service_hooks 
    html = open(
      "https://github.com/%s/%s/edit?login=%s&token=%s" % [
        @username, @repository, @auth[:login], @auth[:token]
      ]
    ).read
    matches = html.scan(/<input.*?id="urls_".*?value="(http:\/\/[^"]+)"[^>]*?>/).flatten
  end

  def add_collaborator(collaborator)
    uri = "https://github.com/api/v2/yaml/repos/collaborators/#{@repository}/add/#{collaborator}?login=%s&token=%s" % [
      @auth[:login], @auth[:token]
    ]
    post( uri )
  end
  
  
  def collaborators_page
    "https://github.com/#{@username}/#{@repository}/edit#collab_bucket"
  end
  
  def owner_type
    octopussy.user(@username)[:type].downcase.to_sym
  end  
  
  def octopussy
    Octopussy::Client.new(@auth)
  end
  
  def post(url, payload = nil)
    uri = URI.parse(url)
    request = ::Net::HTTP::Post.new(uri.request_uri)
    https = ::Net::HTTP.new(uri.host, uri.port) 
    https.use_ssl = true
    https.start do |https|
      response = https.request request, payload
      case response 
      when Net::HTTPClientError, Net::HTTPServerError then raise response.inspect
      end
    end
  end

end