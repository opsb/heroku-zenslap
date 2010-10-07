require 'test_helper'

class GithubClientTest < Test::Unit::TestCase
  context "github client" do
    setup do
      @github_client = GithubClient.new
    end
    
    should "add service hook" do
      @github_client.add_service_hook "http://zenslap.me/pushes"
    end
    
    should "add collaborator"
  end
end