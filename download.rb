require_relative './lib/options_parser'

OPTIONS = OptionsParser.parse

OPTIONS.regions.each do |region|
  File.readlines("data/urls_#{region}").each do |line|
    name = line.split('/').last.split('-').first
    puts name
    path = "data/#{region}/#{name}.html"
    return if File.file?(path)

    download_html("https://www.finanzen.net/bilanz_guv/#{name}", region)
    File.write(path, document.to_html)
    sleep 3
  end
end
