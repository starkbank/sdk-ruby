# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::BoletoHolmes::Log, '#boleto/log#') do
  it 'query logs' do
    logs = StarkBank::BoletoHolmes::Log.query(limit: 10, types: 'solved').to_a
    expect(logs.length).must_equal(10)
    logs.each do |log|
      expect(log.id).wont_be_nil
      expect(log.type).must_equal('solved')
      expect(log.holmes.status).must_equal('solved')
    end
  end

  it 'query and get' do
    log = StarkBank::BoletoHolmes::Log.query(limit: 1).to_a[0]
    get_log = StarkBank::BoletoHolmes::Log.get(log.id)
    expect(log.id).must_equal(get_log.id)
  end
end
