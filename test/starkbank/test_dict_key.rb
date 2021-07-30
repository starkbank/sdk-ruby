# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::DictKey, '#dict-key#') do
  it 'get' do
    pix_key = 'valid@sandbox.com'
    dict_key = StarkBank::DictKey.get(pix_key)
    expect(dict_key.id).must_equal(pix_key)
  end

  it 'query' do
    dict_keys = StarkBank::DictKey.query(type: 'evp', status: 'registered').to_a
    expect(dict_keys.length).must_be(:>=, 1)
    dict_keys.each do |dict_key|
      expect(dict_key.id).wont_be_nil
      expect(dict_key.status).must_equal('registered')
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    dict_keys = nil
    (0..1).step(1) do
      dict_keys, cursor = StarkBank::DictKey.page(limit: 2, cursor: cursor)
      dict_keys.each do |dict_key|
        expect(ids).wont_include(dict_key.id)
        ids << dict_key.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_be :<=, 4
  end
end
