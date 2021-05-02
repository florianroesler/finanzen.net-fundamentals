# encoding: utf-8

require 'open-uri'
require 'net/http'
require 'pry'
require 'nokogiri'
require 'addressable/uri'

class FundamentalsFetcher
  URL_PREFIX = 'https://www.finanzen.net/bilanz_guv/'

  def download_html(url)
    stock_name = url.split('/').last.split('-').first
    stock_url = [URL_PREFIX, stock_name].join

    response = URI.open(Addressable::URI.escape(stock_url), 'User-Agent' => OptionsParser::USER_AGENT).read
    Nokogiri::HTML(response)
  rescue OpenURI::HTTPError => e
    puts "404 for #{name}"
  end
end
