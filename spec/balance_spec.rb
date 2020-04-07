# frozen_string_literal: true

require('starkbank')
require('user')

RSpec.describe(StarkBank::Balance, '#balance') do
  context 'no requirements' do
    it 'get balance' do
      balance = StarkBank::Balance.get
      expect(balance.id).not_to(be_nil)
      expect(balance.amount).not_to(be_nil)
      expect(balance.currency).not_to(be_nil)
      expect(balance.updated).not_to(be_nil)
    end
  end
end
