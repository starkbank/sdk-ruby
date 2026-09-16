# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::MerchantSession, '#merchant-session#') do
  it 'create, query, page and get' do
    session = StarkBank::MerchantSession.create(ExampleGenerator.merchant_session_example)
    expect(session.id).wont_be_nil
    expect(session.uuid).wont_be_nil

    sessions = StarkBank::MerchantSession.query(limit: 1)
    sessions.each do |s|
      expect(s.id).wont_be_nil
    end

    ids = []
    cursor = nil
    (0..1).step(1) do
      page_sessions, cursor = StarkBank::MerchantSession.page(limit: 1, cursor: cursor)

      page_sessions.each do |s|
        expect(ids).wont_include(s.id)
        ids << s.id
      end
      break if cursor.nil?
    end

    get_session = StarkBank::MerchantSession.get(session.id)
    expect(get_session.id).must_equal(session.id)
  end

  it 'purchase' do
    session = StarkBank::MerchantSession.create(ExampleGenerator.merchant_session_example)

    purchase = StarkBank::MerchantSession.purchase(session.uuid, ExampleGenerator.merchant_session_purchase_example)
    expect(purchase.id).wont_be_nil
    expect(purchase.status).wont_be_nil
  end
end
