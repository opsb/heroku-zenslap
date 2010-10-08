class Git
  GITHUB_REGEX = /git@github.com:.+?\b\/.+?\b/  
  HEROKU_GIT_REGEX = /git@heroku.com:(.*)\.git/  
  
  def git_config
    @git_config ||= File.open('./.git/config').read
  end
  
  def heroku_url
    git_config[HEROKU_GIT_REGEX]
  end
  
  def heroku_app
    heroku_url[HEROKU_GIT_REGEX, 1]
  end
  
  def github_credentials
    { :login => retrieve_github('user'), :token => retrieve_github('token') }
  end
  
  def retrieve_github(param)
    value = exec("git config --get github.#{param}").strip
    if value == ""
      begin
        value = ask_for("your github #{param}")
        retry if value == ''
      end
      exec("git config --add github.#{param} #{value}")      
    end
    value
  end
  
  def ask_for(message)
    puts "Please enter #{message}"
    gets.strip
  end
  
  def exec(command)
    `#{command}`
  end    
  
  def github_url
    git_config[GITHUB_REGEX]
  end  
end