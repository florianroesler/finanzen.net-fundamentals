require_relative './lib/options_parser'
require_relative './lib/url_collector'
require_relative './lib//scraper'

OPTIONS = OptionsParser.parse

OPTIONS.regions.each do |region|
  index_urls = INDICES.fetch(region.to_sym)

  collector = UrlCollector.new(Scraper.new)
  stock_urls = index_urls
    .map { |index_url| collector.collect_stock_urls(index_url) }
    .flatten
    .uniq

  IO.write("data/urls_#{region}", stock_urls.join("\n"))
end
