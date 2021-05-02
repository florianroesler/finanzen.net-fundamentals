require_relative '../spec_helper'

RSpec.describe FundamentalsFetcher do
  let(:subject) { FundamentalsFetcher.new }

  describe '#download_html' do
    let(:url) { 'https://www.finanzen.net/aktien/hugo_boss-aktie' }

    it 'returns an html page of the fundamentals' do
      VCR.use_cassette('download_html_hugo_boss') do
        response = subject.download_html(url)

        expect(response.css('.headline-container').first.text).to eq('HUGO BOSS Umsatz, Kennzahlen, Bilanz/GuV')
      end
    end
  end
end
