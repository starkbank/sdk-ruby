# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::CorporateInvoice, '#corporate-invoice#') do
  it 'query' do
    invoices = StarkBank::CorporateInvoice.query(limit: 5)
    invoices.each do |invoice|
      expect(invoice.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    (0..1).step(1) do
      invoices, cursor = StarkBank::CorporateInvoice.page(limit: 5, cursor: cursor)

      invoices.each do |invoice|
        expect(ids).wont_include(invoice.id)
        ids << invoice.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'create' do
    invoice_id = StarkBank::CorporateInvoice.create(ExampleGenerator.corporateinvoice_example).id
    expect(invoice_id).wont_be_nil
  end
end
