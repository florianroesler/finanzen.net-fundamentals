require_relative './lib/options_parser'
require_relative './lib/scraper'

OPTIONS = OptionsParser.parse

scraper = Scraper.new

OPTIONS.regions.each do |region|
  File.readlines("data/urls_#{region}").each do |line|
    name = line.split('/').last.split('-')[..-2].join('-')
    puts name
    path = "data/#{region}/#{name}.html"
    next if File.file?(path)

    response = scraper.scrape("https://www.finanzen.net/bilanz_guv/#{name}")

    if response.status == 200
      File.write(path, response.html)
    else
      puts "#{response.status} for #{name}"
    end

    sleep 2
  end
end
