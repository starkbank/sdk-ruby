# frozen_string_literal: true

require('date')
require('starkbank')
require('user')

RSpec.describe(StarkBank::BoletoPayment, '#boleto-payment#') do
  context 'at least 10 successful boleto payments' do
    it 'query' do
      payments = StarkBank::BoletoPayment.query(limit: 10, status: 'success').to_a
      expect(payments.length).to(eq(10))
      payments.each do |payment|
        expect(payment.id).not_to(be_nil)
        expect(payment.status).to(eq('success'))
      end
    end
  end

  context 'payment of example line is not yet registered' do
    it 'create, get, get_pdf and delete' do
      payment = StarkBank::BoletoPayment.create([example])[0]
      get_payment = StarkBank::BoletoPayment.get(payment.id)
      expect(payment.id).to(eq(get_payment.id))
      pdf = StarkBank::BoletoPayment.pdf(payment.id)
      File.open('boleto_payment.pdf', 'w') { |file| file.write(pdf) }
      delete_payment = StarkBank::BoletoPayment.delete(payment.id)
      expect(payment.id).to(eq(delete_payment.id))
    end
  end

  def example
    StarkBank::BoletoPayment.new(
      line: '34191.09008 61713.957308 71444.640008 2 834300' + rand(1e8 - 1).to_s.rjust(8, '0'),
      scheduled: Date.today + 2,
      description: 'loading a random account',
      tax_id: '20.018.183/0001-80'
    )
  end
end
