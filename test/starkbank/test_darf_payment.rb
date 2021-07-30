# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')
require('date')

describe(StarkBank::DarfPayment, '#darf-payment#') do
  it 'query' do
    payments = StarkBank::DarfPayment.query(limit: 5).to_a
    expect(payments.length).must_equal(5)
    payments.each do |payment|
      expect(payment.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    darf_payments = nil
    (0..1).step(1) do
      darf_payments, cursor = StarkBank::DarfPayment.page(limit: 5, cursor: cursor)
      darf_payments.each do |payment|
        expect(ids).wont_include(payment.id)
        ids << payment.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'create, get, get_pdf and delete' do
    payment = StarkBank::DarfPayment.create([ExampleGenerator.darf_payment_example])[0]
    get_payment = StarkBank::DarfPayment.get(payment.id)
    expect(payment.id).must_equal(get_payment.id)

    pdf = StarkBank::DarfPayment.pdf(payment.id)
    File.binwrite('darf_payment.pdf', pdf)

    delete_payment = StarkBank::DarfPayment.delete(payment.id)
    expect(payment.id).must_equal(delete_payment.id)
  end
end
