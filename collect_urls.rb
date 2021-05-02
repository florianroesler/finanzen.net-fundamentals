require_relative './lib/options_parser'
require_relative './lib/url_collector'

OPTIONS = OptionsParser.parse

OPTIONS.regions.each do |region|
  stock_urls = []
  index_urls = INDICES.fetch(region.to_sym)

  index_urls.each do |index_url|

  end

  IO.write("data/urls_#{region}", stock_urls.join("\n"))
end
