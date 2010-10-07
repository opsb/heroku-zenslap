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
    @global_git_config ||= File.open(File.expand_path('~/.gitconfig')).read
    { :login => CONFIG['GITHUB_LOGIN'], :token => CONFIG['GITHUB_TOKEN'] }
  end    
  
  def github_url
    git_config[GITHUB_REGEX]
  end  
end