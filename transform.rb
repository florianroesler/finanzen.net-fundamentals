# encoding: utf-8

require 'pry'
require 'nokogiri'
require 'csv'
require_relative './lib/options_parser'

OPTIONS = OptionsParser.parse

shares = []

Dir.glob("data/#{OPTIONS.country}/*.html").each do |filename|
  next if filename == '.' or filename == '..'

  file_contents = File.read(filename)
  document = Nokogiri::HTML(file_contents, nil, Encoding::UTF_8.to_s)

  document.css('h2').first.css('span').remove
  share_name = document.css('h2').first.text.encode('UTF-8', invalid: :replace, undef: :replace)
  puts "#{share_name} (#{filename})"

  quote_box = document.css('.quotebox').first
  share_price = quote_box.css('> div').first.text

  eps_table = document.css('.table-quotes').last

  years = eps_table.css('thead th')[2..]&.map(&:text)

  next if years.nil?

  earnings_per_shares = eps_table.css('tr')[1].css('td')[2..].map(&:text)
  dividends = eps_table.css('tr')[5].css('td')[2..].map(&:text)

  values = {}

  values['Name'] = share_name
  values['Share Price'] = share_price

  years.each_with_index do |year, index|
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
