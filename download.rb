# encoding: utf-8

require 'open-uri'
require 'net/http'
require 'pry'
require 'nokogiri'
require 'addressable/uri'

require_relative './lib/options_parser'

OPTIONS = OptionsParser.parse

def download_html(url, region)
  name = url.split('/').last
  path = "data/#{region}/#{name}.html"
  return if File.file?(path)

  response = URI.open(Addressable::URI.escape(url), 'User-Agent' => OPTIONS::USER_AGENT).read
  document = Nokogiri::HTML(response)
  File.write(path, document.to_html)
  sleep 3
rescue OpenURI::HTTPError => e
  puts "404 for #{name}"
end

OPTIONS.regions.each do |region|
  File.readlines("data/urls_#{region}").each do |line|
    name = line.split('/').last.split('-').first
    puts name
    download_html("https://www.finanzen.net/bilanz_guv/#{name}", region)
  end
end
