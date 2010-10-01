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
  REPO = "git@github.com:opsb/zenslap-heroku"
  puts "Installing plugin from #{REPO}"
  puts `heroku plugins:install #{REPO}`
end