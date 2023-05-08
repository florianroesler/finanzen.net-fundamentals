require_relative '../spec_helper'

RSpec.describe FundamentalsExtractor do
  let(:file_contents) { File.read('spec/fixtures/aroundtown.html') }
  let(:subject) { FundamentalsExtractor.new(file_contents) }

  describe '#share_price' do
    it 'returns the share price including currency' do
      expect(subject.share_price).to eq([1.21, 'EUR'])
    end
  end

  describe '#name' do
     it 'returns the stock name' do
      expect(subject.name).to eq('Aroundtown SA')
    end
  end

  describe '#wkn' do
    it 'returns the wkn' do
      expect(subject.wkn).to eq('A2DW8Z')
    end
  end

  describe '#isin' do
    it 'returns the isin' do
      expect(subject.isin).to eq('LU1673108939')
    end
  end

  describe '#reporting_years' do
    it 'returns the years of available reports' do
      expect(subject.reporting_years).to eq(%w[2016 2017 2018 2019 2020 2021 2022])
    end

    context 'when revenue table is not given' do
      let(:file_contents) { File.read('spec/fixtures/daimler_truck.html') }
      let(:subject) { FundamentalsExtractor.new(file_contents) }

      it 'returns an empty array' do
        expect(subject.reporting_years).to eq([])
      end
    end
  end

  describe '#revenues' do
    it 'extracts the revenues per year' do
      expect(subject.revenues).to eq(
        {
          '2016' => 0.41,
          '2017' => 0.58,
          '2018' => 0.69,
          '2019' => 0.76,
          '2020' => 0.90,
          '2021' => 1.13,
          '2022' => 1.45,
        }
      )
    end

    context 'when revenue table is not given' do
      let(:file_contents) { File.read('spec/fixtures/daimler_truck.html') }
      let(:subject) { FundamentalsExtractor.new(file_contents) }

      it 'returns an empty hash' do
        expect(subject.revenues).to eq({})
      end
    end
  end

  describe '#earnings' do
    it 'extracts the earnings per year' do
      expect(subject.earnings).to eq(
        {
          '2016' => 1.11,
          '2017' => 1.56,
          '2018' => 1.54,
          '2019' => 1.12,
          '2020' => 0.50,
          '2021' => 0.55,
          '2022' => -0.58,
        }
      )
    end

    context 'when revenue table is not given' do
      let(:file_contents) { File.read('spec/fixtures/daimler_truck.html') }
      let(:subject) { FundamentalsExtractor.new(file_contents) }

      it 'returns an empty hash' do
        expect(subject.earnings).to eq({})
      end
    end
  end

  describe '#dividends' do
    it 'extracts dividends per year' do
      expect(subject.dividends).to eq(
        {
          '2016' => 0.16,
          '2017' => 0.23,
          '2018' => 0.25,
          '2019' => 0.14,
          '2020' => 0.22,
          '2021' => 0.23,
        }
      )
    end

    context 'when revenue table is not given' do
      let(:file_contents) { File.read('spec/fixtures/daimler_truck.html') }
      let(:subject) { FundamentalsExtractor.new(file_contents) }

      it 'returns an empty hash' do
        expect(subject.dividends).to eq({})
      end
    end
  end

  describe '#yearly_performance' do
    it 'lists the years and the corresponding fundamentals' do
      expect(subject.yearly_performance).to eq(
        {
          '2016' => { dividend: 0.16, eps: 1.11, revenue: 0.41 },
          '2017' => { dividend: 0.23, eps: 1.56, revenue: 0.58 },
          '2018' => { dividend: 0.25, eps: 1.54, revenue: 0.69 },
          '2019' => { dividend: 0.14, eps: 1.12, revenue: 0.76 },
          '2020' => { dividend: 0.22, eps: 0.50, revenue: 0.90 },
          '2021' => { dividend: 0.23, eps: 0.55, revenue: 1.13 },
          '2022' => { dividend: nil, eps: -0.58, revenue: 1.45 },
        }
      )
    end

    context 'when revenue table is not given' do
      let(:file_contents) { File.read('spec/fixtures/daimler_truck.html') }
      let(:subject) { FundamentalsExtractor.new(file_contents) }

      it 'returns an empty hash' do
        expect(subject.yearly_performance).to eq({})
      end
    end
  end

  describe '#reporting_currency' do
    it 'extracts the reporting currency' do
      expect(subject.reporting_currency).to eq('EUR')
    end
  end
end
