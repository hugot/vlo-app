class Command

  def initialize(options)
    @options = options
  end

  # Create an associative array representing an option and its
  # description.
  def self.mkopt(short, long, descr)
    return {
      :short => short,
      :long  => long,
      :descr => descr
    }
  end

end
