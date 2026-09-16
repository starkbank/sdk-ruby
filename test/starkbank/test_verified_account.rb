# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::VerifiedAccount, '#verified_account#') do
  it 'query' do
    accounts = StarkBank::VerifiedAccount.query(limit: 10).to_a
    accounts.each do |account|
      expect(account.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    accounts = nil
    (0..1).step(1) do
      accounts, cursor = StarkBank::VerifiedAccount.page(limit: 5, cursor: cursor)
      accounts.each do |account|
        expect(ids).wont_include(account.id)
        ids << account.id
      end
      break if cursor.nil?
    end
  end

  it 'create with bank info, get and cancel' do
    account = StarkBank::VerifiedAccount.create([ExampleGenerator.verified_account_bank_info_example])[0]
    get_account = StarkBank::VerifiedAccount.get(account.id)
    expect(account.id).must_equal(get_account.id)
    canceled_account = StarkBank::VerifiedAccount.cancel(account.id)
    expect(account.id).must_equal(canceled_account.id)
    expect(canceled_account.status).must_equal('canceled')
  end

  it 'create with pix key and cancel' do
    account = StarkBank::VerifiedAccount.create([ExampleGenerator.verified_account_pix_key_example])[0]
    expect(account.id).wont_be_nil
    canceled_account = StarkBank::VerifiedAccount.cancel(account.id)
    expect(account.id).must_equal(canceled_account.id)
    expect(canceled_account.status).must_equal('canceled')
  end

  it 'query with filters' do
    StarkBank::VerifiedAccount.query(
      limit: 5,
      status: 'active',
      after: Date.today - 30,
      before: Date.today,
      ids: ['5656565656565656'],
      tags: ['verified-account-test']
    ).to_a
  end
end
