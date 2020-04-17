# frozen_string_literal: true

require('securerandom')
require('date')
require('starkbank')
require('user')

RSpec.describe(StarkBank::Transaction, '#transaction#') do
  context 'at least 10 transactions created on past 30 days' do
    it 'query' do
      after = Date.today - 30
      transactions = StarkBank::Transaction.query(limit: 10, after: after).to_a
      expect(transactions.length).to(eq(10))
      transactions.each do |transaction|
        expect(transaction.id).not_to(be_nil)
        expect(transaction.created).to(be >= after)
      end
    end
  end

  context 'no requirements' do
    it 'create and get' do
      transaction = example
      create_transaction = StarkBank::Transaction.create([transaction])[0]
      expect(-transaction.amount).to(eq(create_transaction.amount))
      get_transaction = StarkBank::Transaction.get(create_transaction.id)
      expect(create_transaction.id).to(eq(get_transaction.id))
      expect(create_transaction.amount).to(eq(get_transaction.amount))
    end
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
