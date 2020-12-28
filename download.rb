# encoding: utf-8

require 'open-uri'
require 'net/http'
require 'pry'
require 'nokogiri'
require 'addressable/uri'

require_relative './lib/options_parser'

USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64e) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.66 Safari/537.36'

OPTIONS = OptionsParser.parse

def download_html(url)
  name = url.split('/').last
  path = "data/#{OPTIONS.region}/#{name}.html"
  return if File.file?(path)

  response = URI.open(Addressable::URI.escape(url), 'User-Agent' => USER_AGENT).read
  document = Nokogiri::HTML(response)
  File.write(path, document.to_html)
  sleep 3
rescue OpenURI::HTTPError => e
  puts "404 for #{name}"
end

File.readlines("urls_#{OPTIONS.region}").eaech do |line|
  name = line.split('/').last.split('-').first
  puts name
  download_html("https://www.finanzen.net/bilanz_guv/#{name}")
end