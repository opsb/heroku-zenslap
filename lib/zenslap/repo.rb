class Repo
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
      value = ask_for("your github #{param}")
      exec("git config --add github.#{param} #{value}")
    end
    value
  end
  
  def ask_for(message)
    value = ""
    while value == ""
      puts "Please enter #{message}"
      value = gets.strip
    end
    value
  end
  
  def exec(command)
    `#{command}`
  end    
  
  def github_url
    github_remotes = git_repo.remotes.select{ |r| r.url =~ GITHUB_REGEX }
    raise "None of the remotes point to github" if github_remotes.empty?
    github_remotes.length == 1 ? github_remotes.first.url : choose_one( github_remotes ).url
  end 
  
  def choose_one
    raise "not implemented"
  end
  
  def git_repo
    Git.open('.')
  end
end