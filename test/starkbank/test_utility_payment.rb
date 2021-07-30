# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')
require('date')

describe(StarkBank::UtilityPayment, '#utility-payment#') do
  it 'query' do
    payments = StarkBank::UtilityPayment.query(limit: 10, status: 'success').to_a
    expect(payments.length).must_equal(10)
    payments.each do |payment|
      expect(payment.id).wont_be_nil
      expect(payment.status).must_equal('success')
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    utility_payments = nil
    (0..1).step(1) do
      utility_payments, cursor = StarkBank::UtilityPayment.page(limit: 5, cursor: cursor)
      utility_payments.each do |utility_payment|
        expect(ids).wont_include(utility_payment.id)
        ids << utility_payment.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'create, get, get_pdf and delete' do
    payment = StarkBank::UtilityPayment.create([ExampleGenerator.utility_payment_example])[0]
    get_payment = StarkBank::UtilityPayment.get(payment.id)
    expect(payment.id).must_equal(get_payment.id)
    pdf = StarkBank::UtilityPayment.pdf(payment.id)
    File.binwrite('utility_payment.pdf', pdf)
    delete_payment = StarkBank::UtilityPayment.delete(payment.id)
    expect(payment.id).must_equal(delete_payment.id)
  end
end
