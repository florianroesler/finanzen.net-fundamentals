# encoding: utf-8

require 'pry'
require 'nokogiri'

class FundamentalsExtractor
  def initialize(file_contents)
    @file_contents = file_contents
  end

  def document
    @document ||= Nokogiri::HTML(@file_contents, nil, Encoding::UTF_8.to_s)
  end

  def name
    document
      .css('h2')
      .first
      .text
      .encode('UTF-8', invalid: :replace, undef: :replace)
      .split('Aktie')
      .first
      .strip
  end

  def wkn
    document.css('.badge.pointer .badge__value').first.text
  end

  def isin
    document.css('.badge.pointer .badge__value')[1].text
  end

  def share_price
    value_box = document.css('.snapshot__values .snapshot__value-current')
    return unless value_box

    [
      text_to_number(value_box.css('.snapshot__value').text),
      value_box.css('.snapshot__value-unit').text
    ]
  end

  def reporting_years
    @reporting_years ||= begin
      revenue_table.css('thead th')[1..]&.map(&:text)
    end
  end

  def revenues
    @revenues ||= begin
      revenues = revenue_table.css('tr')[1].css('td')[1..].map { |element| text_to_number(element.text) }

      reporting_years.zip(revenues).to_h
    end
  end

  def earnings_and_dividends
    @earnings_and_dividends ||= begin
      eps_table = earnings_table

      earnings_per_shares = eps_table.css('tr')[1].css('td')[1..].map { |element| text_to_number(element.text) }
      dividends = eps_table.css('tr')[3].css('td')[1..].map { |element| text_to_number(element.text) }

      reporting_years.zip(earnings_per_shares, dividends).each_with_object({}) do |values, hash|
        year, eps, dividend = values
        hash[year] = { eps: eps, dividend: dividend }
      end
    end
  end

  def reporting_currency
    header = revenue_table.css('h2')&.text&.encode('UTF-8', invalid: :replace, undef: :replace)

    return if header.nil?

    matching_string = header.match(/\((.+)\)/)&.captures&.first

    return if matching_string.nil?

    matching_string.split(' ').last
  end

  private

  def earnings_table
    document.css('.page-content__container .page-content__item')[2]
  end

  def revenue_table
    document.css('.page-content__container .page-content__item')[3]
  end

  def text_to_number(text)
    return nil if text == '-'

    text.gsub('.', '').gsub(',', '.').to_f
  end
end
