require('starkbank')
require('user')

RSpec.describe(StarkBank::Balance, '#get') do
  context 'default user set' do
    it 'get balance' do
      balance = StarkBank::Balance.get
      expect(balance.id).not_to(be_nil)
      expect(balance.amount).not_to(be_nil)
      expect(balance.currency).not_to(be_nil)
      expect(balance.updated).not_to(be_nil)
    end
  end
end
