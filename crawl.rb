require 'open-uri'
# encoding: utf-8

require 'net/http'
require 'pry'
require 'nokogiri'
USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.66 Safari/537.36'

def download_html(url)
  name = url.split('/').last
  path = "data/#{name}.html"
  return if File.file?(path)

  response = URI.open(url, 'User-Agent' => USER_AGENT).read
  document = Nokogiri::HTML(response)
  File.write(path, document.to_html)
  sleep 3
rescue OpenURI::HTTPError => e
  puts "404 for #{name}"
end

File.readlines('urls_de').each do |line|
  name = line.split('/').last.split('-').first
  puts name
  download_html("https://www.finanzen.net/bilanz_guv/#{name}")
end
