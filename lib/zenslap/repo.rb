require 'git'

class Repo
  GITHUB_REGEX = /github.com[:\/](\S+)\/(\S+?)(?:\.git)?$/
  HEROKU_GIT_REGEX = /git@heroku\..*?:(.*)\.git/  
  
  def github_url
    @github_url ||= find_url("---> Which github repository do you want to use?", GITHUB_REGEX, "No github remotes found. You need to add one to your git config before you can add zenslap.")
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
  
  def github_credentials
    { :login => retrieve_github('user'), :token => retrieve_github('token') }
  end
  
  def add_zenslap_remote(name)
    git_repo.add_remote name, "git@heroku.com:#{name}.git"
  end
  
  def add_zenslap_id_to_zenslap_remote(zenslap_id)
    git_repo.config("remote.zenslap.zenslap-id", zenslap_id)
  end
  
  def zenslap_app
    HEROKU_GIT_REGEX.match(git_repo.remote("zenslap").url)[1]
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
  
  def owner
    @owner ||= parse_github_url[0]
  end
  
  def name
    @name ||= parse_github_url[1]
  end
  
  private 
  
  def parse_github_url
    search_result = /github.com[:\/](\S+)\/(\S+?)(?:\.git)?$/.match(github_url)
    raise InvalidUrlError, github_url if search_result.blank? || search_result[1].blank? || search_result[2].blank?
    owner, name = search_result[1..2]
  end
end