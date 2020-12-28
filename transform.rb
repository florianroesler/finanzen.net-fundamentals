# encoding: utf-8

require 'pry'
require 'nokogiri'
require 'csv'
require_relative './lib/options_parser'

OPTIONS = OptionsParser.parse

shares = []

def text_to_number(text)
  text.gsub('.', '').gsub(',', '.').to_f
end

def extract_name(document)
  document
    .css('h2')
    .first
    .text
    .encode('UTF-8', invalid: :replace, undef: :replace)
    .split('Aktie').first
end

def extract_share_price(document)
  quote_box = document.css('.quotebox').last
  return unless quote_box

  price_with_currency = quote_box.css('> div').first.text.strip

  price, currency = price_with_currency.match(/([\d\.]+,\d+)(\w+)/i).captures

  [text_to_number(price), currency]
end

def extract_earnings_and_dividends(document)
  eps_table = document.css('.table-quotes').last

  earnings_per_shares = eps_table.css('tr')[1].css('td')[2..].map { |element| text_to_number(element.text) }
  dividends = eps_table.css('tr')[5].css('td')[2..].map { |element| text_to_number(element.text) }

  [earnings_per_shares, dividends]
end

def extract_revenues(document)
  revenue_table = document.css('.table-quotes')[1]

  years = revenue_table.css('thead th')[2..]&.map(&:text)

  return if years.nil?

  revenues = revenue_table.css('tr')[1].css('td')[2..].map { |element| text_to_number(element.text) }

  [years, revenues]
end

Dir.glob("data/#{OPTIONS.country}/*.html").each do |filename|
  next if filename == '.' or filename == '..'

  file_contents = File.read(filename)
  document = Nokogiri::HTML(file_contents, nil, Encoding::UTF_8.to_s)

  document.css('h2').first.css('span').remove
  share_name = extract_name(document)
  puts "#{share_name} (#{filename})"

  share_price, currency = extract_share_price(document)
  next if share_price.nil?

  years, revenues = extract_revenues(document)
  next if years.nil?

  earnings_per_shares, dividends = extract_earnings_and_dividends(document)

  values = {}

  values['Name'] = share_name
  values['Share Price'] = share_price
  values['Currency'] = currency

  years.each_with_index do |year, index|
    values["Revenue #{year}"] = revenues[index]
    values["EPS #{year}"] = earnings_per_shares[index]
    values["Dividend #{year}"] = dividends[index]
  end

  shares << values
end

puts "Writing #{shares.size} rows"

CSV.open("data_#{OPTIONS.country}.csv", 'wb', write_headers: true) do |csv|
  keys = shares.map(&:keys).flatten.uniq
  csv << keys
  shares.each do |share|
    csv << CSV::Row.new(keys, share.values_at(*keys))
  end
end
