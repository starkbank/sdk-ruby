# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::Transfer, '#transfer#') do
  it 'query' do
    transfers = StarkBank::Transfer.query(limit: 10, status: 'success').to_a
    expect(transfers.length).must_equal(10)
    transfers.each do |transfer|
      expect(transfer.id).wont_be_nil
      expect(transfer.status).must_equal('success')
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    transfers = nil
    (0..1).step(1) do
      transfers, cursor = StarkBank::Transfer.page(limit: 5, cursor: cursor)
      transfers.each do |transfer|
        expect(ids).wont_include(transfer.id)
        ids << transfer.id
      end
      if cursor.nil?
        break
      end
    end
    expect(ids.length).must_equal(10)
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

    transfers_ids_expected = transfers_ids_expected.sort
    transfers_ids_result = transfers_ids_result.sort
    expect(transfers_ids_expected).must_equal(transfers_ids_result)
  end

  it 'create, get and get_pdf' do
    transfer = StarkBank::Transfer.create([ExampleGenerator.transfer_example])[0]
    get_transfer = StarkBank::Transfer.get(transfer.id)
    expect(transfer.id).must_equal(get_transfer.id)
    pdf = StarkBank::Transfer.pdf(transfer.id)
    File.binwrite('transfer.pdf', pdf)
  end

  it 'create and delete' do
    transfer = ExampleGenerator.transfer_example(schedule: true)
    transfer = StarkBank::Transfer.create([transfer])[0]
    delete_transfer = StarkBank::Transfer.delete(transfer.id)
    expect(transfer.id).must_equal(delete_transfer.id)
    expect(delete_transfer.status).must_equal('canceled')
  end
end
