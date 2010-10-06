require 'test_helper'

class RepositoryTest < Test::Unit::TestCase
  context "a repository" do
    
    USERNAME = CONFIG["GITHUB_LOGIN"]
    TOKEN = CONFIG["GITHUB_TOKEN"]
    
    setup do
      stub_request(:get, "http://github.com/opsb/zenslap/edit?login=#{USERNAME}&token=#{TOKEN}").
                    to_return(:body => GITHUB_SERVICE_HOOKS_PAGE)
                    
      stub_request(:post, "http://github.com/opsb/zenslap/edit?login=#{USERNAME}&token=#{TOKEN}")
      @repository = Repository.new "git@github.com:opsb/zenslap"
      @github_client = mock
      @repository.stubs(:github_client).returns(@github_client)
    end
    
    should "have service hooks" do
      assert_equal @repository.service_hooks, ["http://pivotaltracker.com", "http://fogbugz.com"]
    end
    
    should "add service hooks" do
      @repository.expects(:service_hooks).returns ["http://pivotaltracker.com"]
      stub_request(:post, "https://github.com/opsb/zenslap/edit/postreceive_urls").
                    with(:body => {
                      "urls" => ["http://pivotaltracker.com", "http://bugtracker.com"], 
                      "login" => USERNAME,
                      "token" => TOKEN
                    }).
                    to_return( :status => 302 )
            
      @repository.add "http://bugtracker.com"
      
      assert_requested(:post, "https://github.com/opsb/zenslap/edit/postreceive_urls")
    end

    should "add zenslap as a github collaborator" do
      @github_client.stubs(:add_collaborator)
      @repository.add_zenslap_collaborator
      assert_received @github_client, :add_collaborator do |expect|
        expect.with "opsb/zenslap", "zenslap"
      end
    end
  end
  
  GITHUB_SERVICE_HOOKS_PAGE = %{
    <html>
      <body>
        <dl class="form">
          <dd>
            <input type="text" value="http://pivotaltracker.com" name="urls[]" id="urls_" autocomplete="off">
            <input type="text" value="http://fogbugz.com" name="urls[]" id="urls_" autocomplete="off">            
          </dd>
        </dl>
      </body>
    </html> 
  }
end

