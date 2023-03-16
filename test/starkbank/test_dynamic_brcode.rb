# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::DynamicBrcode, '#dynamic-brcode#') do
  it 'query' do
    brcodes = StarkBank::DynamicBrcode.query(limit: 10).to_a
    expect(brcodes.length).must_equal(10)
    brcodes.each do |brcode|
      expect(brcode.uuid).wont_be_nil
    end
  end

  it 'page' do
    uuids = []
    cursor = nil
    brcodes = nil
    (0..1).step(1) do
      brcodes, cursor = StarkBank::DynamicBrcode.page(limit: 5, cursor: cursor)
      brcodes.each do |brcode|
        expect(uuids).wont_include(brcode.uuid)
        uuids << brcode.uuid
      end
      break if cursor.nil?
    end
    expect(uuids.length).must_equal(10)
  end

  it 'create and get' do
    brcode = StarkBank::DynamicBrcode.create([ExampleGenerator.dynamic_brcode_example])[0]
    get_brcode = StarkBank::DynamicBrcode.get(brcode.uuid)
    expect(brcode.uuid).must_equal(get_brcode.uuid)
  end
end
