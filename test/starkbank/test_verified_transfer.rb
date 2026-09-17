# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::VerifiedTransfer, '#verified_transfer#') do
  it 'create' do
    account = StarkBank::VerifiedAccount.create([ExampleGenerator.verified_account_bank_info_example])[0]
    verified_transfer = StarkBank::VerifiedTransfer.create([ExampleGenerator.verified_transfer_example(account.id)])[0]
    expect(verified_transfer.id).wont_be_nil
    get_transfer = StarkBank::Transfer.get(verified_transfer.id)
    expect(get_transfer.id).must_equal(verified_transfer.id)
  end
end
