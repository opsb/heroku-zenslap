require 'open-uri'
require 'net/https'
require 'set'
require 'octopussy'

class GithubClient
  
  def initialize(git_url, auth)
    search_result = /github.com[:\/](\S+)\/(\S+?)(?:\.git)?$/.match(git_url)
    raise InvalidUrlError, git_url if search_result.blank? || search_result[1].blank? || search_result[2].blank?
    @owner, @repository = search_result[1..2]
    @auth = auth
  end
  
  def add_service_hook(service_hook)
    all_hooks = (service_hooks + [service_hook]).uniq
    params = { :urls => all_hooks, :login => @auth[:login], :token => @auth[:token]}
    RestClient.post("https://github.com/#{@owner}/#{@repository}/edit/postreceive_urls", params) do |response, request, result, &block|
      case response.code
      when 302
        response
      else
        response.return!(request, result, &block)
      end
    end
  end
  
  def add_team
    params = { :team => {:name => "zenslap", :permission => "pull"}, :login => @auth[:login], :token => @auth[:token]}
    RestClient.post("https://github.com/organizations/#{@owner}/teams/create", params) do |response, request, result, &block|
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
        @owner, @repository, @auth[:login], @auth[:token]
      ]
    ).read
    matches = html.scan(/<input.*?id="urls_".*?value="(http:\/\/[^"]+)"[^>]*?>/).flatten
  end

  def add_collaborator(collaborator)
    RestClient.post("https://github.com/api/v2/yaml/repos/collaborators/#{@repository}/add/#{collaborator}", {:login => @auth[:login], :token => @auth[:token]})
  end
  
  
  def collaborators_page
    "https://github.com/#{@owner}/#{@repository}/edit#collab_bucket"
  end
  
  def owner_type
    octopussy.user(@owner)[:type].downcase.to_sym
  end  
  
  def octopussy
    Octopussy::Client.new(@auth)
  end

end