require 'open-uri'

class GithubClient
  def add_service_hook(service_hook)
    puts service_hooks
  end
  
  def service_hooks
    WebMock.allow_net_connect!    
    html = open(
      "https://github.com/%s/%s/edit?login=%s&token=%s" % [
        "opsb",
        "conference_hub",
        CONFIG['GITHUB_LOGIN'],
        CONFIG['GITHUB_TOKEN']
      ]
    ).read
    matches = html.scan(/<input.*?id="urls_".*?value="(http:\/\/[^"]+)"[^>]/)
    WebMock.disable_net_connect!    
    matches
  end
  
  def add_collaborator(collaborator)
    raise "not implemented"
  end
  
end

__END__


(?:<input.*value="([^"]+)".*id="urls_")*

<input type="text" value="http://news.ycombinator.com" name="urls[]" id="urls_" autocomplete="off"><input type="text" value="http://news.ycombinator.com" name="urls[]" id="urls_" autocomplete="off">