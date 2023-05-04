# frozen_string_literal: false

require_relative('../test_helper.rb')

describe(StarkBank::CorporateBalance, '#corporate-balance#') do
  it 'get success' do
    balance = StarkBank::CorporateBalance.get
    expect(balance.id).wont_be_nil
    expect(balance.amount).wont_be_nil
    expect(balance.currency).wont_be_nil
    expect(balance.updated).wont_be_nil
  end
end
