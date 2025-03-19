# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::MerchantCard::Log, '#merchant_card/log#') do
  it 'query logs' do
    logs = StarkBank::MerchantCard::Log.query(limit: 10).to_a
    expect(logs.length).must_equal(10)
    logs.each do |log|
      expect(log.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    logs = nil
    (0..1).step(1) do
      logs, cursor = StarkBank::MerchantCard::Log.page(limit: 5, cursor: cursor)
      logs.each do |log|
        expect(ids).wont_include(log.id)
        ids << log.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'query and get' do
    log = StarkBank::MerchantCard::Log.query(limit: 1).to_a[0]
    get_log = StarkBank::MerchantCard::Log.get(log.id)
    expect(log.id).must_equal(get_log.id)
  end
end
