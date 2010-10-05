require 'rubygems'
require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

desc "install from github"
task "install" do
  REPO = "git@github.com:opsb/heroku-zenslap"
  puts "Installing plugin from #{REPO}"
  puts `heroku plugins:install #{REPO}`
end

desc "publish from github to herocutter"
task "publish" do
  REPO = "git://github.com/opsb/heroku-zenslap"  
  `heroku plugins:push #{REPO}`
end