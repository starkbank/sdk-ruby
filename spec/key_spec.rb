require('starkbank')

RSpec.describe(StarkBank::Key, '#create') do
  context 'no requirements' do
    it 'generates new random ECDSA key pair' do
      private_key, public_key = StarkBank::Key.create
      expect(private_key).not_to(be_empty)
      expect(public_key).not_to(be_empty)
    end
  end
  context 'no requirements' do
    it 'generates new random ECDSA key pair and saves to folder keys' do
      private_key, public_key = StarkBank::Key.create('keys')
      expect(private_key).not_to(be_empty)
      expect(public_key).not_to(be_empty)
    end
  end
end
