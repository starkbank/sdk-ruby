# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::DictKey, '#dict-key#') do
  it 'get' do
    pix_key = 'tony@starkbank.com'
    dict_key = StarkBank::DictKey.get(pix_key)
    expect(dict_key.id).must_equal(pix_key)
  end
end
