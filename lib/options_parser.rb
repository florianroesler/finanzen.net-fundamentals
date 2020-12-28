require 'getoptlong'

class OptionsParser
  attr_reader :region

  def initialize
    opts = GetoptLong.new(
      [ '--region', GetoptLong::REQUIRED_ARGUMENT ]
    )

    opts.each do |opt, arg|
      @region = arg if opt == '--region'
    end

    raise(ArgumentError, 'Missing region argument') unless @region
  end

  def self.parse
    self.new
  end
end
