require 'test_helper'

class GithubClientTest < Test::Unit::TestCase
  context "github client" do
    GITHUB_URL = "git@github.com:opsb/conference_hub"
    GITHUB_CREDENTIALS = { :login => 'jimbo', :token => 'randomhash'}
    URL_ENCODED_CREDENTIALS = GITHUB_CREDENTIALS.map{ |k,v| "#{k}=#{v}" }.join("&")
    
    setup do
      @github_client = GithubClient.new(GITHUB_URL, GITHUB_CREDENTIALS )
    end
    
    should "add service hook" do
      stub_request(:get, "https://github.com/opsb/conference_hub/edit?#{URL_ENCODED_CREDENTIALS}").
                    to_return(:body => '<input autocomplete="off" id="urls_" name="urls[]" type="text" value="http://news.ycombinator.com">')
                    
      stub_request(:post, "https://github.com/opsb/conference_hub/edit/postreceive_urls?#{URL_ENCODED_CREDENTIALS}").
                    to_return(:status => 302)
                    
      @github_client.add_service_hook "http://zenslap.me/pushes"
    end
    
    should "add collaborator" do
      stub_request(:post, "https://github.com/api/v2/yaml/repos/collaborators/conference_hub/add/zenslap?#{URL_ENCODED_CREDENTIALS}").
                    to_return(:status => 200)
      
      @github_client.add_collaborator "zenslap"
    end
  end
end