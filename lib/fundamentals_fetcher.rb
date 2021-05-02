# encoding: utf-8

require 'open-uri'
require 'net/http'
require 'pry'
require 'nokogiri'
require 'addressable/uri'

class FundamentalsFetcher
  URL_PREFIX = 'https://www.finanzen.net/bilanz_guv/'

  attr_reader :document

  def initialize(base_url)
    @base_url = base_url
  end

  def download_html
    response = URI.open(Addressable::URI.escape(fundamentals_url), 'User-Agent' => OptionsParser::USER_AGENT).read
    @document = Nokogiri::HTML(response)
  rescue OpenURI::HTTPError => e
    puts "404 for #{name}"
  end

  def name
    document
      .css('h2')
      .first
      .text
      .encode('UTF-8', invalid: :replace, undef: :replace)
      .split('Aktie')
      .first
      .strip
  end

  def share_price
    quote_box = document.css('.quotebox').first
    return unless quote_box

    price_with_currency = quote_box.css('> div').first.text.strip

    price, currency = price_with_currency.match(/([\d\.]+,\d+)(\w+)/i).captures

    [text_to_number(price), currency]
  end

  def reporting_years
    @reporting_years ||= begin
      revenue_table = document.css('.table-quotes')[1]
      revenue_table.css('thead th')[2..]&.map(&:text)
    end
  end

  def revenues
    @revenues ||= begin
      revenue_table = document.css('.table-quotes')[1]
      revenues = revenue_table.css('tr')[1].css('td')[2..].map { |element| text_to_number(element.text) }

      reporting_years.zip(revenues).to_h
    end
  end

  def earnings_and_dividends
    @earnings_and_dividends ||= begin
      eps_table = document.css('.table-quotes').last

      earnings_per_shares = eps_table.css('tr')[1].css('td')[2..].map { |element| text_to_number(element.text) }
      dividends = eps_table.css('tr')[5].css('td')[2..].map { |element| text_to_number(element.text) }

      reporting_years.zip(earnings_per_shares, dividends).each_with_object({}) do |values, hash|
        year, eps, dividend = values
        hash[year] = { eps: eps, dividend: dividend }
      end
    end
  end

  def reporting_currency
    revenue_table = document.css('.table-quotes').first

    header = revenue_table.css('h2')&.text&.encode('UTF-8', invalid: :replace, undef: :replace)

    return if header.nil?

    matching_string = header.match(/\((.+)\)/)&.captures&.first

    return if matching_string.nil?

    matching_string.split(' ').last
  end

  private

  def url_stock_path
    @base_url.split('/').last.split('-').first
  end

  def fundamentals_url
    [URL_PREFIX, url_stock_path].join
  end

  def text_to_number(text)
    text.gsub('.', '').gsub(',', '.').to_f
  end
end
