class Repo
  GITHUB_REGEX = /git@github.com:.+?\b\/.+?\b/  
  HEROKU_GIT_REGEX = /git@heroku.com:(.*)\.git/  
  
  def heroku_url
    find_url(HEROKU_GIT_REGEX, "No heroku remotes found")
  end
  
  def github_url
    find_url(GITHUB_REGEX, "No github remotes found")
  end
  
  def find_url(regex, message)
    remotes = git_repo.remotes.select{ |r| r.url =~ regex }
    raise message if remotes.empty?
    remotes.length == 1 ? remotes.first.url : choose_one( remotes ).url
  end
  
  def choose_one(remotes)
    names = remotes.map &:name
    begin 
      puts names
      name = gets.chomp
    end while not names.include? name
    remotes.find{ |r| r.name == name }
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
  
  def git_repo
    Git.open('.')
  end
end