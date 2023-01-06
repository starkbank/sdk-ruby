# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::Institution, '#institution#') do
  it 'query' do
    institutions = StarkBank::Institution.query(search: 'stark').to_a
    expect(institutions.length).must_equal(2)

    institutions = StarkBank::Institution.query(spi_codes: '20018183').to_a
    expect(institutions.length).must_equal(1)

    institutions = StarkBank::Institution.query(str_codes: '341').to_a
    expect(institutions.length).must_equal(1)
  end
end
