# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::Invoice, '#invoice#') do
  it 'query' do
    invoices = StarkBank::Invoice.query(limit: 10, status: 'paid', before: DateTime.now).to_a
    expect(invoices.length).must_equal(10)
    invoices.each do |invoice|
      expect(invoice.id).wont_be_nil
      expect(invoice.status).must_equal('paid')
    end
  end

  it 'create, get, get qrcode and cancel' do
    invoice = StarkBank::Invoice.create([ExampleGenerator.invoice_example])[0]
    get_invoice = StarkBank::Invoice.get(invoice.id)
    expect(invoice.id).must_equal(get_invoice.id)
    _invoice_qrcode = StarkBank::Invoice.qrcode(invoice.id)
    canceled_invoice = StarkBank::Invoice.update(invoice.id, status: 'canceled')
    expect(invoice.id).must_equal(canceled_invoice.id)
  end

  it 'create and update' do
    invoice = StarkBank::Invoice.create([ExampleGenerator.invoice_example])[0]
    get_invoice = StarkBank::Invoice.get(invoice.id)
    expect(invoice.id).must_equal(get_invoice.id)
    updated_invoice = StarkBank::Invoice.update(invoice.id, amount: 100, expiration: 3600, due: Time.now + 86400 * 10)
    expect(invoice.id).must_equal(updated_invoice.id)
  end

  it 'payment' do
    invoices = StarkBank::Invoice.query(status: 'paid', limit: 1).to_a
    payment_info = StarkBank::Invoice.payment(invoices[0].id)
    expect(payment_info.name).wont_be_nil
  end
end
