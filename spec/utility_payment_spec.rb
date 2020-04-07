# frozen_string_literal: true

require('date')
require('starkbank')
require('user')

RSpec.describe(StarkBank::UtilityPayment, '#utilitypayment') do
  context 'at least 10 successful utility payments' do
    it 'query' do
      payments = StarkBank::UtilityPayment.query(limit: 10, status: 'success').to_a
      expect(payments.length).to(eq(10))
      payments.each do |payment|
        expect(payment.id).not_to(be_nil)
        expect(payment.status).to(eq('success'))
      end
    end
  end

  context 'payment of example line is not yet registered' do
    it 'create, get, get_pdf and delete' do
      payment = StarkBank::UtilityPayment.create(payments: [example])[0]
      get_payment = StarkBank::UtilityPayment.get(id: payment.id)
      expect(payment.id).to(eq(get_payment.id))
      pdf = StarkBank::UtilityPayment.pdf(id: payment.id)
      File.open('utility_payment.pdf', 'w') { |file| file.write(pdf) }
      delete_payment = StarkBank::UtilityPayment.delete(id: payment.id)
      expect(payment.id).to(eq(delete_payment.id))
    end
  end

  def example
    StarkBank::UtilityPayment.new(
      bar_code: '83660000001084301380074119002551100010601813',
      scheduled: Date.today + 2,
      description: 'pagando a conta'
    )
  end
end
