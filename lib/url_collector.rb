# encoding: utf-8

require 'open-uri'
require 'net/http'
require 'pry'
require 'nokogiri'

require_relative './options_parser'
require_relative './indices'

class UrlCollector
  def collect_stock_urls(index_url)
    index_pages = collect_index_pages(index_url)

    index_pages
      .map { |page| collect_stock_urls_for_page(page) }
      .flatten
      .uniq
  end

  def collect_index_pages(index_url)
    response = URI.open(index_url, 'User-Agent' => OptionsParser::USER_AGENT).read
    document = Nokogiri::HTML(response)

    page_links = document.css('.pagination__list a').map { |link| link.attr('href') }

    if page_links.any?
      puts "Found #{page_links.size} pages for #{index_url}"
      page_links.map { |page_link| [index_url, page_link].join }
    else
      puts "Found only single page for #{index_url}"
      [index_url]
    end
  rescue OpenURI::HTTPError => e
    puts "#{response.status} for #{index_url}"
    []
  end

  def collect_stock_urls_for_page(index_url)
    response = URI.open(index_url, 'User-Agent' => OptionsParser::USER_AGENT).read
    document = Nokogiri::HTML(response)

    puts "Collecting Stocks from #{index_url}"
    sleep 3

    document.css('#index-list-container tr a').map { |link| link.attr('href') }
  rescue OpenURI::HTTPError => e
    puts "#{response.status} for #{index_url}"
    []
  end
end
