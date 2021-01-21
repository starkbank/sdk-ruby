# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::BrcodePayment, '#brcode-payment#') do
  it 'query' do
    payments = StarkBank::BrcodePayment.query(limit: 10, status: 'failed').to_a
    expect(payments.length).must_equal(10)
    payments.each do |payment|
      expect(payment.id).wont_be_nil
      expect(payment.status).must_equal('failed')
    end
  end

  it 'create and get' do
    invoices = StarkBank::Invoice.create([ExampleGenerator.invoice_example, ExampleGenerator.invoice_example])
    payment = StarkBank::BrcodePayment.create([ExampleGenerator.brcode_payment_example(invoice: invoices[0]), ExampleGenerator.brcode_payment_example(invoice: invoices[1])])[0]
    get_payment = StarkBank::BrcodePayment.get(payment.id)
    expect(payment.id).must_equal(get_payment.id)
  end

  it 'query and cancel' do
    payment = StarkBank::BrcodePayment.query(limit: 1, status: 'created').to_a[0]
    cancel_payment = StarkBank::BrcodePayment.update(payment.id, status: 'canceled')
    expect(payment.id).must_equal(cancel_payment.id)
    expect(cancel_payment.status).must_equal('canceled')
  end
end
