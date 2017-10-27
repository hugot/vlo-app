class CourseCommand < Command
  
  def self.opt_a
    return [
      mkopt("-l", "--list", "List subscripted courses")
    ]
  end

  def execute
    if @options['-l']
      puts "Lijst van courses"
    else
      puts "Course command zonder options"
    end
  end

end
