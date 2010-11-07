require File.dirname(__FILE__) + '/zenslap/console_error'
require File.dirname(__FILE__) + '/zenslap/zenslap_client'
require File.dirname(__FILE__) + '/zenslap/git_repo'
require File.dirname(__FILE__) + '/heroku/commands/zenslap'

Heroku::Command::Help.group('zenslap') do |group|
  group.command 'add', 'adds continuous integration to your project'
end