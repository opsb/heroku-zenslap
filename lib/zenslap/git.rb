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
    { :login => exec("git config --get github.user").strip, :token => exec("git config --get github.token").strip }
  end
  
  def exec(command)
    `#{command}`
  end    
  
  def github_url
    git_config[GITHUB_REGEX]
  end  
end