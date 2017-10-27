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
  command_opts.each do |gen_opt|
    opt.on(gen_opt[:short], gen_opt[:long], gen_opt[:descr]) do |arg|
      options[gen_opt[:short]] = arg
    end
  end
end.parse!(ARGV.to_a)

p options
p ARGV

execute(options)
