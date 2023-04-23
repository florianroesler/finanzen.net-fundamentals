require 'puppeteer-ruby'
require 'pry-byebug'

class Scraper
  def scrape(url)
    page = browser.new_page
    page.viewport = Puppeteer::Viewport.new(width: 1280, height: 800)
    response = page.goto(url, wait_until: 'domcontentloaded')

    html = page.evaluate(<<~JAVASCRIPT)
    () => document.body.innerHTML
    JAVASCRIPT

    OpenStruct.new(
      status: response.status,
      html: html
    )
  end

  def browser
    @browser ||= Puppeteer.launch(
      headless: true, slow_mo: 50, args: ['--window-size=1280,800', '--no-sandbox', '--disable-setuid-sandbox']
    )
  end
end
