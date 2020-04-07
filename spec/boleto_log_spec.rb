# frozen_string_literal: true

require('starkbank')
require('user')

RSpec.describe(StarkBank::BoletoLog, '#boletolog') do
  context 'at least 10 paid boletos' do
    it 'query logs' do
      logs = StarkBank::BoletoLog.query(limit: 10, types: 'paid').to_a
      expect(logs.length).to(eq(10))
      logs.each do |log|
        expect(log.id).not_to(be_nil)
        expect(log.type).to(eq('paid'))
        expect(log.boleto.status).to(eq('paid'))
      end
    end
  end

  context 'at least one created boleto' do
    it 'query and get' do
      log = StarkBank::BoletoLog.query(limit: 1).to_a[0]
      get_log = StarkBank::BoletoLog.get(id: log.id)
      expect(log.id).to(eq(get_log.id))
      puts log
    end
  end
end
