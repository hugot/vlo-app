require_relative '../api/vlo_api.rb'
require 'io/console'
class CourseCommand < Command
  
  def self.opt_a
    return [
      mkopt("-l", "--list", "List subscripted courses")
    ]
  end

  def execute
    if @options['-l']
      if ENV["VLO_UNAME"] == nil
        print "Username: "
        uname = gets.chomp
      else
        uname = ENV["VLO_UNAME"]
      end
      if ENV["VLO_PASSWD"] == nil
        print "Password: "
        pw = STDIN.noecho(&:gets).chomp
      else
        pw = ENV["VLO_PASSWD"]
      end
      api = VloApi.new(uname, pw)
      api.find_personal_course.map do |course|
        puts course[:name]
      end
    else
      puts "Course command zonder options"
    end
  end

end
