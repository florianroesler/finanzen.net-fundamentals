# encoding: utf-8

require 'pry'
require 'csv'
require_relative './lib/options_parser'
require_relative './lib/fundamentals_extractor'

OPTIONS = OptionsParser.parse

OPTIONS.regions.each do |region|
  shares = []

  Dir.glob("data/#{region}/*.html").each do |filename|
    next if filename == '.' or filename == '..'

    file_contents = File.read(filename)
    extractor = FundamentalsExtractor.new(file_contents)

    share_name = extractor.name
    puts "#{share_name} (#{filename})"

    share_price, currency = extractor.share_price
    next if share_price.nil?

    values = {}

    values['Name'] = share_name
    values['Share Price'] = share_price
    values['Currency'] = currency
    values['Reporting Currency'] = extractor.reporting_currency

    extractor.yearly_performance.each do |year, performance|
      values["Revenue #{year}"] = performance[:revenue]
      values["EPS #{year}"] = performance[:eps]
      values["Dividend #{year}"] = performance[:dividend]
    end

    shares << values
  end

  puts "Writing #{shares.size} rows"

  CSV.open("data_#{region}.csv", 'wb', write_headers: true) do |csv|
    keys = shares.map(&:keys).flatten.uniq
    csv << keys
    shares.each do |share|
      csv << CSV::Row.new(keys, share.values_at(*keys))
    end
  end
end
