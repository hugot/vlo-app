require 'optparse'
require_relative 'command'
require_relative 'course_command'

command_opts = []

command = ARGV.shift
#TODO: Actually make this message helpful
help = "Help message"

case command
when "course"
  command_opts = CourseCommand.opt_a
  def execute(options)
    CourseCommand.new(options).execute
  end
else
  puts help
  exit 1
end

options = {}
OptionParser.new do |opt|
  command_opts.each do |command_opt|
    opt.on(command_opt[:short], command_opt[:long], command_opt[:descr]) do |arg|
      options[command_opt[:short]] = arg
    end
  end
end.parse!(ARGV.to_a)

execute(options)
