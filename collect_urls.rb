# encoding: utf-8

require 'open-uri'
require 'net/http'
require 'pry'
require 'nokogiri'

require_relative './lib/options_parser'
require_relative './lib/indices'

OPTIONS = OptionsParser.parse

def collect_index_pages(index_url)
  response = URI.open(index_url, 'User-Agent' => OPTIONS::USER_AGENT).read
  document = Nokogiri::HTML(response)

  page_links = document.css('.finando_paging a').map { |link| link.attr('href') }
  sleep 3

  if page_links.any?
    puts "Found #{page_links.size} pages for #{index_url}"
    page_links.map { |page_link| [index_url, page_link].join }
  else
    puts "Found only single page for #{index_url}"
    [index_url]
  end
rescue OpenURI::HTTPError => e
  puts "404 for #{name}"
end

def collect_stock_urls(index_url)
  response = URI.open(index_url, 'User-Agent' => OPTIONS::USER_AGENT).read
  document = Nokogiri::HTML(response)

  puts "Collecting Stocks from #{index_url}"
  sleep 3

  document.css('#index-list-container tr a').map { |link| link.attr('href') }
rescue OpenURI::HTTPError => e
  puts "404 for #{name}"
end

OPTIONS.regions.each do |region|
  stock_urls = []
  index_urls = INDICES.fetch(region.to_sym)

  index_urls.each do |index_url|
    index_pages = collect_index_pages(index_url)

    index_pages.each do |index_page|
      stock_urls += collect_stock_urls(index_page)
    end
  end

  IO.write("data/urls_#{region}", stock_urls.join("\n"))
end
