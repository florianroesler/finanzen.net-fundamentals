require_relative '../spec_helper'

RSpec.describe FundamentalsFetcher do
  let(:base_url) { 'https://www.finanzen.net/aktien/hugo_boss-aktie' }
  let(:subject) { FundamentalsFetcher.new(base_url) }
  let(:vcr_name ) { 'download_html_hugo_boss' }

  around do |example|
    VCR.use_cassette(vcr_name) { example.run }
  end

  describe '#document' do
    it 'returns an html page of the fundamentals' do
      response = subject.document
      expect(response.css('.headline-container').first.text).to eq('HUGO BOSS Umsatz, Kennzahlen, Bilanz/GuV')
    end
  end

  describe '#share_price' do
    it 'returns the share price including currency' do
      expect(subject.share_price).to eq([38.33, 'EUR'])
    end
  end

  describe '#name' do
     it 'returns the stock name' do
      expect(subject.name).to eq('HUGO BOSS')
    end
  end

  describe '#wkn' do
    it 'returns the wkn' do
      expect(subject.wkn).to eq('A1PHFF')
    end
  end

  describe '#isin' do
    it 'returns the isin' do
      expect(subject.isin).to eq('DE000A1PHFF7')
    end
  end

  describe '#reporting_years' do
    it 'returns the years of available reports' do
      expect(subject.reporting_years).to eq(%w[2014 2015 2016 2017 2018 2019 2020])
    end
  end

  describe '#revenues' do
    it 'extracts the revenues per year' do
      expect(subject.revenues).to eq(
        {
          '2014' => 37.26,
          '2015' => 40.70,
          '2016' => 39.02,
          '2017' => 39.59,
          '2018' => 40.51,
          '2019' => 41.79,
          '2020' => 28.19
        }
      )
    end
  end

  describe '#earnings_and_dividends' do
    it 'extracts the earings and dividends per year' do
      expect(subject.earnings_and_dividends).to eq(
        {
          '2014' => { dividend: 3.62, eps: 4.83},
          '2015' => { dividend: 3.62, eps: 4.63},
          '2016' => { dividend: 2.6, eps: 2.8},
          '2017' => { dividend: 2.65, eps: 3.35},
          '2018' => { dividend: 2.7, eps: 3.42},
          '2019' => { dividend: 0.04, eps: 2.97},
          '2020' => { dividend: 0.04, eps: -3.18},
        }
      )
    end
  end

  describe '#reporting_currency' do
    it 'extracts the reporting currency' do
      expect(subject.reporting_currency).to eq('EUR')
    end
  end
end
