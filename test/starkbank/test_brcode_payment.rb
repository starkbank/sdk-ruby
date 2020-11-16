# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::BrcodePayment, '#brcode-payment#') do
  it 'query' do
    payments = StarkBank::BrcodePayment.query(limit: 10, status: 'success').to_a
    expect(payments.length).must_equal(10)
    payments.each do |payment|
      expect(payment.id).wont_be_nil
      expect(payment.status).must_equal('success')
    end
  end

  it 'create and get' do
    payment = StarkBank::BrcodePayment.create([ExampleGenerator.brcode_payment_example])[0]
    get_payment = StarkBank::BrcodePayment.get(payment.id)
    expect(payment.id).must_equal(get_payment.id)
  end
end
