require('key')

RSpec.describe(StarkBank::Key, '#create') do
  context 'no requirements' do
    it 'generates new random ECDSA key pair' do
      private, public = StarkBank::Key.create
      expect(private).not_to(be_empty)
      expect(public).not_to(be_empty)
    end
  end
  context 'no requirements' do
    it 'generates new random ECDSA key pair and saves to folder keys' do
      private, public = StarkBank::Key.create('keys')
      expect(private).not_to(be_empty)
      expect(public).not_to(be_empty)
    end
  end
end
