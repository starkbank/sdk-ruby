# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')
require('date')

describe(StarkBank::TaxPayment, '#tax-payment#') do
  it 'query' do
    payments = StarkBank::TaxPayment.query(limit: 5).to_a
    expect(payments.length).must_equal(5)
    payments.each do |payment|
      expect(payment.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    tax_payments = nil
    (0..1).step(1) do
      tax_payments, cursor = StarkBank::TaxPayment.page(limit: 5, cursor: cursor)
      tax_payments.each do |payment|
        expect(ids).wont_include(payment.id)
        ids << payment.id
      end
      if cursor.nil?
        break
      end
    end
    expect(ids.length).must_equal(10)
  end

  it 'create, get, get_pdf and delete' do
    payment = StarkBank::TaxPayment.create([ExampleGenerator.tax_payment_example])[0]
    get_payment = StarkBank::TaxPayment.get(payment.id)
    expect(payment.id).must_equal(get_payment.id)

    pdf = StarkBank::TaxPayment.pdf(payment.id)
    File.binwrite('tax_payment.pdf', pdf)

    delete_payment = StarkBank::TaxPayment.delete(payment.id)
    expect(payment.id).must_equal(delete_payment.id)
  end
end
