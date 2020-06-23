# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::Balance, '#balance#') do
  it 'get balance' do
    balance = StarkBank::Balance.get
    expect(balance.id).wont_be_nil
    expect(balance.amount).wont_be_nil
    expect(balance.currency).wont_be_nil
    expect(balance.updated).wont_be_nil
  end
end
