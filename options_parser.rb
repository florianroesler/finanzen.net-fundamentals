require 'getoptlong'

class OptionsParser
  attr_reader :country

  def initialize
    opts = GetoptLong.new(
      [ '--country', GetoptLong::REQUIRED_ARGUMENT ]
    )

    opts.each do |opt, arg|
      @country = arg if opt == '--country'
    end
  end

  def self.parse
    self.new
  end
end
