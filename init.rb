require File.dirname(__FILE__) + '/lib/heroku/commands/zenslap'

Heroku::Command::Help.group('zenslap') do |group|
  group.command 'add', 'adds continuous integration to your project'
end