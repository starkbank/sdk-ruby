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

  it 'query' do
    transfers = StarkBank::Transfer.query(limit: 10).to_a
    expect(transfers.length).must_equal(10)
    transfers_ids_expected = []
    transfers.each do |transfer|
      transfers_ids_expected.push(transfer.id)
    end

    transfers_ids_result = []
    StarkBank::Transfer.query(limit: 10, ids: transfers_ids_expected).each do |transfer|
      transfers_ids_result.push(transfer.id)
    end

    transfers_ids_expected = transfers_ids_expected.sort()
    transfers_ids_result = transfers_ids_result.sort()
    expect(transfers_ids_expected).must_equal(transfers_ids_result)
  end

  it 'create, get and get_pdf' do
    transfer = StarkBank::Transfer.create([example])[0]
    get_transfer = StarkBank::Transfer.get(transfer.id)
    expect(transfer.id).must_equal(get_transfer.id)
    pdf = StarkBank::Transfer.pdf(transfer.id)
    File.binwrite('transfer.pdf', pdf)
  end

  it 'create and delete' do
    transfer = example(schedule: true)
    transfer = StarkBank::Transfer.create([transfer])[0]
    delete_transfer = StarkBank::Transfer.delete(transfer.id)
    expect(transfer.id).must_equal(delete_transfer.id)
    expect(delete_transfer.status).must_equal('canceled')
  end

  def example(schedule: false)
    StarkBank::Transfer.new(
      amount: rand(1000),
      name: 'João',
      tax_id: '01234567890',
      bank_code: '01',
      branch_code: '0001',
      account_number: '10000-0',
      scheduled: schedule ? Time.now + 24 * 3600 : nil
    )
  end
end
