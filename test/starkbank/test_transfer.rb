# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::Transfer, '#transfer#') do
  it 'query' do
    transfers = StarkBank::Transfer.query(limit: 10, status: 'success').to_a
    expect(transfers.length).must_equal(10)
    transfers.each do |transfer|
      expect(transfer.id).wont_be_nil
      expect(transfer.status).must_equal('success')
    end
  end

  it 'create, get and get_pdf' do
    transfer = StarkBank::Transfer.create([example])[0]
    get_transfer = StarkBank::Transfer.get(transfer.id)
    expect(transfer.id).must_equal(get_transfer.id)
    pdf = StarkBank::Transfer.pdf(transfer.id)
    File.open('transfer.pdf', 'w') { |file| file.write(pdf) }
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
