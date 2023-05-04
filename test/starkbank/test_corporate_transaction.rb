# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::CorporateTransaction, '#corporate-transaction#') do
  it 'query' do
    transactions = StarkBank::CorporateTransaction.query(limit: 5)
    transactions.each do |transaction|
      expect(transaction.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    (0..1).step(1) do
      transactions, cursor = StarkBank::CorporateTransaction.page(limit: 5, cursor: cursor)

      transactions.each do |transaction|
        expect(ids).wont_include(transaction.id)
        ids << transaction.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'query and get' do
    transaction = StarkBank::CorporateTransaction.query(limit: 1).first

    transaction = StarkBank::CorporateTransaction.get(transaction.id)
    expect(transaction.id).wont_be_nil
  end
end
