require 'test_helper'

class GithubClientTest < Test::Unit::TestCase
  context "github client" do
    GITHUB_URL = "git@github.com:opsb/conference_hub"
    
    setup do
      @github_client = GithubClient.new(GITHUB_URL)
    end
    
    should "add service hook" do
      stub_request(:get, "https://github.com/opsb/conference_hub/edit?login=#{CONFIG['GITHUB_LOGIN']}&token=#{CONFIG['GITHUB_TOKEN']}").
                    to_return(:body => '<input autocomplete="off" id="urls_" name="urls[]" type="text" value="http://news.ycombinator.com">')
                    
      stub_request(:post, "https://github.com/opsb/conference_hub/edit/postreceive_urls?login=#{CONFIG['GITHUB_LOGIN']}&token=#{CONFIG['GITHUB_TOKEN']}").
                    to_return(:status => 302)
                    
      @github_client.add_service_hook "http://zenslap.me/pushes"
    end
    
    should "add collaborator" do
      stub_request(:post, "https://github.com/api/v2/yaml/repos/collaborators/conference_hub/add/zenslap?login=#{CONFIG['GITHUB_LOGIN']}&token=#{CONFIG['GITHUB_TOKEN']}").
                    to_return(:status => 200)
      
      @github_client.add_collaborator "zenslap"
    end
  end
end