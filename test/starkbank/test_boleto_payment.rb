# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::BoletoPayment, '#boleto-payment#') do
  it 'query' do
    payments = StarkBank::BoletoPayment.query(limit: 10, status: 'success').to_a
    expect(payments.length).must_equal(10)
    payments.each do |payment|
      expect(payment.id).wont_be_nil
      expect(payment.status).must_equal('success')
    end
  end

  it 'create, get, get_pdf and delete' do
    payment = StarkBank::BoletoPayment.create([example])[0]
    get_payment = StarkBank::BoletoPayment.get(payment.id)
    expect(payment.id).must_equal(get_payment.id)
    pdf = StarkBank::BoletoPayment.pdf(payment.id)
    File.binwrite('boleto_payment.pdf', pdf)
    delete_payment = StarkBank::BoletoPayment.delete(payment.id)
    expect(payment.id).must_equal(delete_payment.id)
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
