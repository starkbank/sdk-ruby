# frozen_string_literal: true

require_relative('../test_helper.rb')
require('securerandom')
require('date')

describe(StarkBank::Transaction, '#transaction#') do
  it 'query' do
    after = Date.today - 30
    transactions = StarkBank::Transaction.query(limit: 10, after: after).to_a
    expect(transactions.length).must_equal(10)
    transactions.each do |transaction|
      expect(transaction.id).wont_be_nil
      expect(transaction.created).must_be(:>=, after)
    end
  end

  it 'create and get' do
    transaction = example
    create_transaction = StarkBank::Transaction.create([transaction])[0]
    expect(-transaction.amount).must_equal(create_transaction.amount)
    get_transaction = StarkBank::Transaction.get(create_transaction.id)
    expect(create_transaction.id).must_equal(get_transaction.id)
    expect(create_transaction.amount).must_equal(get_transaction.amount)
  end

  def example
    StarkBank::Transaction.new(
      amount: 50,
      receiver_id: '5768064935133184',
      external_id: SecureRandom.base64,
      description: 'Transferência para Workspace aleatório'
    )
  end
end