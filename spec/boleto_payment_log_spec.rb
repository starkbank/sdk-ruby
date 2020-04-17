# frozen_string_literal: true

require('starkbank')
require('user')

RSpec.describe(StarkBank::BoletoPayment::Log, '#boleto-payment/log#') do
  context 'at least 10 successful boleto payments' do
    it 'query logs' do
      logs = StarkBank::BoletoPayment::Log.query(limit: 10, types: 'success').to_a
      expect(logs.length).to(eq(10))
      logs.each do |log|
        expect(log.id).not_to(be_nil)
        expect(log.type).to(eq('success'))
        expect(log.payment.status).to(eq('success'))
      end
    end
  end

  context 'at least one created boleto payment' do
    it 'query and get' do
      log = StarkBank::BoletoPayment::Log.query(limit: 1).to_a[0]
      get_log = StarkBank::BoletoPayment::Log.get(log.id)
      expect(log.id).to(eq(get_log.id))
    end
  end
end
