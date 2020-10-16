# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

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
    payment = StarkBank::BoletoPayment.create([ExampleGenerator.boleto_payment_example])[0]
    get_payment = StarkBank::BoletoPayment.get(payment.id)
    expect(payment.id).must_equal(get_payment.id)
    pdf = StarkBank::BoletoPayment.pdf(payment.id)
    File.binwrite('boleto_payment.pdf', pdf)
    delete_payment = StarkBank::BoletoPayment.delete(payment.id)
    expect(payment.id).must_equal(delete_payment.id)
  end

end
