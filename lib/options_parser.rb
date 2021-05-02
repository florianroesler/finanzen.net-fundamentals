require 'getoptlong'

class OptionsParser
  attr_reader :regions

  USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.66 Safari/537.36'

  def initialize
    opts = GetoptLong.new(
      [ '--regions', GetoptLong::REQUIRED_ARGUMENT ]
    )

    opts.each do |opt, arg|
      @regions = arg.split(',') if opt == '--regions'
    end

    raise(ArgumentError, 'Missing regions argument') unless @regions
  end

  def self.parse
    self.new
  end
end
