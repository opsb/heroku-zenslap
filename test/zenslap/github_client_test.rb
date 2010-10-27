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
                    
      stub_request(:post, "https://github.com/opsb/conference_hub/edit/postreceive_urls").
                    with(:body => GITHUB_CREDENTIALS.merge({:urls => ["http://news.ycombinator.com", "http://zenslap.me/pushes"]})).
                    to_return(:status => 302)
                    
      @github_client.add_service_hook "http://zenslap.me/pushes"
    end
    
    should "add zenslap team to organisation" do
      stub_request(:post, "https://github.com/organizations/opsb/teams/create").
                    with(:body => GITHUB_CREDENTIALS.merge({:team=>{:permission=>"pull", :name=>"zenslap"}})).
                    to_return(:status => 302)
      @github_client.add_team
    end
    
    should "not add duplicate service hooks" do
      stub_request(:get, "https://github.com/opsb/conference_hub/edit?#{URL_ENCODED_CREDENTIALS}").
                    to_return(:body => '<input autocomplete="off" id="urls_" name="urls[]" type="text" value="http://news.ycombinator.com">')
                    
      stub_request(:post, "https://github.com/opsb/conference_hub/edit/postreceive_urls").
                    with(:body => GITHUB_CREDENTIALS.merge({:urls => ["http://news.ycombinator.com"]})).
                    to_return(:status => 302)
                           
      @github_client.add_service_hook "http://news.ycombinator.com"
    end
    
    should "add collaborator" do
      stub_request(:post, "https://github.com/api/v2/yaml/repos/collaborators/conference_hub/add/zenslap?#{URL_ENCODED_CREDENTIALS}").
                    to_return(:status => 200)
      
      @github_client.add_collaborator "zenslap"
    end
    

    should "have a collaborators page" do
      assert_equal @github_client.collaborators_page, "https://github.com/opsb/conference_hub/edit#collab_bucket"
    end
    
    context "for an organisation project" do
      setup do
        @github_client.stubs(:octopussy).returns(
          mock('user') do
            expects(:user).with('opsb').returns({ :type => "Organization" })
          end
        )
      end
      
      should "have project type of 'organization'" do
        assert_equal @github_client.owner_type, :organization
      end
    end
    
    context "for a user project" do
      setup do
        @github_client.stubs(:octopussy).returns(
          stub(:user => { :type => "User" })
        )
      end
      
      should "have owner type of 'user'" do
        assert_equal @github_client.owner_type, :user
      end
    end
    
  end
end