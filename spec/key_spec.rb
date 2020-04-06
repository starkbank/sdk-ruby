require('key')

RSpec.describe(Key, '#create') do
  context 'no requirements' do
    it 'generates new random ECDSA key pair' do
      private, public = Key.create
      expect(private).not_to(be_empty)
      expect(public).not_to(be_empty)
    end
  end
  context 'no requirements' do
    it 'generates new random ECDSA key pair and saves to folder keys' do
      private, public = Key.create('keys')
      expect(private).not_to(be_empty)
      expect(public).not_to(be_empty)
    end
  end
end
