require_relative '../spec_helper'

RSpec.describe UrlCollector do
  let(:subject) { UrlCollector.new }

  describe '#collect_index_pages' do
    it 'collects all sub pages for the given index' do
      VCR.use_cassette('collect_index_pages_s_and_p_500') do
        expect(subject.collect_index_pages(INDICES[:us].first))
          .to eq(
            [
              'https://www.finanzen.net/index/s&p_500/werte?p=1',
              'https://www.finanzen.net/index/s&p_500/werte?p=2',
              'https://www.finanzen.net/index/s&p_500/werte?p=3',
              'https://www.finanzen.net/index/s&p_500/werte?p=4',
              'https://www.finanzen.net/index/s&p_500/werte?p=5',
              'https://www.finanzen.net/index/s&p_500/werte?p=6',
              'https://www.finanzen.net/index/s&p_500/werte?p=7',
              'https://www.finanzen.net/index/s&p_500/werte?p=8',
              'https://www.finanzen.net/index/s&p_500/werte?p=9',
              'https://www.finanzen.net/index/s&p_500/werte?p=10'
            ]
          )
      end
    end

    context 'when the index only has a single page' do
      it 'only collects a single page' do
        VCR.use_cassette('collect_index_pages_dax') do
          expect(subject.collect_index_pages(INDICES[:de].first))
            .to eq(['https://www.finanzen.net/index/dax/30-werte'])
        end
      end
    end
  end

  describe '#collect_stock_urls_for_page' do
    let(:page_url) { 'https://www.finanzen.net/index/dax/30-werte' }

    it 'collects all stock urls from the page' do
      VCR.use_cassette('collect_stock_urls_for_page_dax') do
        expect(subject.collect_stock_urls_for_page(page_url))
          .to eq(
            [
              '/aktien/adidas-aktie',
              '/aktien/allianz-aktie',
              '/aktien/basf-aktie',
              '/aktien/bayer-aktie',
              '/aktien/bmw-aktie',
              '/aktien/continental-aktie',
              '/aktien/covestro-aktie',
              '/aktien/daimler-aktie',
              '/aktien/delivery_hero-aktie',
              '/aktien/deutsche_bank-aktie',
              '/aktien/deutsche_boerse-aktie',
              '/aktien/deutsche_post-aktie',
              '/aktien/deutsche_telekom-aktie',
              '/aktien/deutsche_wohnen-aktie',
              '/aktien/eon-aktie',
              '/aktien/fresenius-aktie',
              '/aktien/fresenius_medical_care-aktie',
              '/aktien/heidelbergcement-aktie',
              '/aktien/henkel_vz-aktie',
              '/aktien/infineon-aktie',
              '/aktien/linde-aktie',
              '/aktien/merck-aktie',
              '/aktien/mtu-aktie',
              '/aktien/munich_re-aktie',
              '/aktien/rwe-aktie',
              '/aktien/sap-aktie',
              '/aktien/siemens-aktie',
              '/aktien/siemens_energy-aktie',
              '/aktien/volkswagen_vz-aktie',
              '/aktien/vonovia-aktie'
            ]
          )
      end
    end
  end
end
