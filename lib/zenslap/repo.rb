require 'git'

class Repo
  GITHUB_REGEX = /git@github.com:.+?\b\/.+?\b/  
  HEROKU_GIT_REGEX = /git@heroku.com:(.*)\.git/  
  
  def heroku_url
    find_url("---> Which heroku app do you want to add the plugin to?", HEROKU_GIT_REGEX, "No heroku remotes found. You need to add one to your git config before you can add zenslap.")
  end
  
  def github_url
    find_url("---> Which github repository do you want to use?", GITHUB_REGEX, "No github remotes found. You need to add one to your git config before you can add zenslap.")
  end
  
  def find_url(help, regex, message)
    remotes = git_repo.remotes.select{ |r| r.url =~ regex }
    raise ConsoleError.new(message) if remotes.empty?
    remotes.length == 1 ? remotes.first.url : choose_one( help, remotes ).url
  end
  
  def choose_one(help, remotes)
    names = remotes.map &:name
    begin 
      puts help
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
      puts "---> Please enter #{message}"
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