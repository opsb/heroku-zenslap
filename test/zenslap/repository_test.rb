require 'test_helper'

class RepositoryTest < Test::Unit::TestCase
  context "a repository" do
    
    USERNAME = "opsb"
    TOKEN = "123"
    
    setup do
      stub_request(:get, "http://github.com/opsb/zenslap/edit?login=#{USERNAME}&token=#{TOKEN}").
                    to_return(:body => GITHUB_SERVICE_HOOKS_PAGE)
                    
      stub_request(:post, "http://github.com/opsb/zenslap/edit?login=#{USERNAME}&token=#{TOKEN}")
      
      @repository = Repository.new "git@github.com:opsb/zenslap", 
                                   :login => USERNAME, 
                                   :token => TOKEN
    end
    
    should "have service hooks" do
      assert_equal @repository.service_hooks, ["http://pivotaltracker.com", "http://fogbugz.com"]
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

