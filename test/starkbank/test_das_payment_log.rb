# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::DasPayment::Log, '#das-payment/log#') do
  it 'query logs' do
    logs = StarkBank::DasPayment::Log.query(limit: 10, types: 'success').to_a
    expect(logs.length).must_equal(10)
    logs.each do |log|
      expect(log.id).wont_be_nil
      expect(log.type).must_equal('success')
      expect(log.payment.status).must_equal('success')
    end
  end

  it 'query and get' do
    log = StarkBank::DasPayment::Log.query(limit: 1).to_a[0]
    get_log = StarkBank::DasPayment::Log.get(log.id)
    expect(log.id).must_equal(get_log.id)
  end
end
