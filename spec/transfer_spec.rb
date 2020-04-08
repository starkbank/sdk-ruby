# frozen_string_literal: true

require('starkbank')
require('user')

RSpec.describe(StarkBank::Transfer, '#transfer#') do
  context 'at least 10 successful transfers' do
    it 'query' do
      transfers = StarkBank::Transfer.query(limit: 10, status: 'success').to_a
      expect(transfers.length).to(eq(10))
      transfers.each do |transfer|
        expect(transfer.id).not_to(be_nil)
        expect(transfer.status).to(eq('success'))
      end
    end
  end

  context 'no requirements' do
    it 'create, get and get_pdf' do
      transfer = StarkBank::Transfer.create(transfers: [example])[0]
      get_transfer = StarkBank::Transfer.get(id: transfer.id)
      expect(transfer.id).to(eq(get_transfer.id))
      pdf = StarkBank::Transfer.pdf(id: transfer.id)
      File.open('transfer.pdf', 'w') { |file| file.write(pdf) }
    end
  end

  def example
    StarkBank::Transfer.new(
      amount: rand(1000),
      name: 'João',
      tax_id: '01234567890',
      bank_code: '01',
      branch_code: '0001',
      account_number: '10000-0'
    )
  end
end
