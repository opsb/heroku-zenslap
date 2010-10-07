require 'test_helper'

class GithubClientTest < Test::Unit::TestCase
  context "github client" do
    setup do
      @github_client = GithubClient.new
    end
    
    should "add service hook" do
      stub_request(:get, "https://github.com/opsb/conference_hub/edit?login=#{CONFIG['GITHUB_LOGIN']}&token=#{CONFIG['GITHUB_TOKEN']}").
                    to_return(:body => '<input autocomplete="off" id="urls_" name="urls[]" type="text" value="http://news.ycombinator.com">')
      @github_client.add_service_hook "http://zenslap.me/pushes"
    end
    
    should "add collaborator"
  end
end