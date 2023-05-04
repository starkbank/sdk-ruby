# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::MerchantCountry, '#merchant-country#') do
  it 'query' do
    countries = StarkBank::MerchantCountry.query(search: 'brazil').to_a

    countries.each do |country|
      assert !country.nil?
      expect(countries.length).must_equal(1)
    end
  end
end
