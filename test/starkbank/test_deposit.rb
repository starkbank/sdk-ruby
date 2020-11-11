# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::Deposit, '#deposit#') do
  it 'query' do
    deposits = StarkBank::Deposit.query(limit: 10, status: 'created', before: DateTime.now).to_a
    expect(deposits.length).must_equal(10)
    deposits.each do |deposit|
      expect(deposit.id).wont_be_nil
      expect(deposit.status).must_equal('created')
    end
  end

  it 'query and get' do
    deposits = StarkBank::Deposit.query(limit: 1).to_a
    get_deposit = StarkBank::Deposit.get(deposits[0].id)
    expect(deposits[0].id).must_equal(get_deposit.id)
  end
end
