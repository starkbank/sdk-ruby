# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator')
require('date')

describe(StarkBank::Transaction, '#transaction#') do
  it 'query and get' do
    after = Date.today - 30
    transactions = StarkBank::Transaction.query(limit: 10, after: after).to_a
    expect(transactions.length).must_equal(10)
    transactions.each do |transaction|
      expect(transaction.id).wont_be_nil
      expect(transaction.created).must_be(:>=, after)
      get_transaction = StarkBank::Transaction.get(transaction.id)
      expect(transaction.id).must_equal(get_transaction.id)
      expect(transaction.amount).must_equal(get_transaction.amount)
    end
  end

  it 'query' do
    transactions = StarkBank::Transaction.query(limit: 10).to_a
    expect(transactions.length).must_equal(10)
    transactions_ids_expected = []
    transactions.each do |transaction|
      transactions_ids_expected.push(transaction.id)
    end

    transactions_ids_result = []
    StarkBank::Transaction.query(limit: 10, ids: transactions_ids_expected).each do |transaction|
      transactions_ids_result.push(transaction.id)
    end

    transactions_ids_expected = transactions_ids_expected.sort()
    transactions_ids_result = transactions_ids_result.sort()
    expect(transactions_ids_expected).must_equal(transactions_ids_result)
  end

  it 'page' do
    ids = []
    cursor = nil
    transactions = nil
    (0..1).step(1) do
      transactions, cursor = StarkBank::Transaction.page(limit: 5, cursor: cursor)
      transactions.each do |transaction|
        expect(ids).wont_include(transaction.id)
        ids << transaction.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'create' do
    transaction = ExampleGenerator.transaction_example
    error = expect { StarkBank::Transaction.create([transaction])[0] }.must_raise(RuntimeError)
    expect(error.message).must_equal("Function deprecated since 2.15.0")
  end

end
