# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::MerchantSession, '#merchant_session#') do
  it 'create' do
    merchant_session_json = ExampleGenerator.generate_example_merchant_session_json("disabled")
    merchant_session = StarkBank::MerchantSession.create(merchant_session_json)
    expect(merchant_session.id).wont_be_nil
  end

  it 'query' do
    merchant_sessions = StarkBank::MerchantSession.query(limit: 3).to_a
    merchant_sessions.each do |merchant_session|
      expect(merchant_session.id).wont_be_nil
    end
  end

  it 'get' do
    merchant_sessions = StarkBank::MerchantSession.query(limit: 3).to_a
    merchant_sessions.each do |session|
      merchant_session = StarkBank::MerchantSession.get(session.id)
      expect(merchant_session.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    (0..1).step(1) do
      page, cursor = StarkBank::MerchantSession.page(limit: 5, cursor: cursor)
      page.each do |entity|
        expect(ids).wont_include(entity.id)
        ids << entity.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'purchase challenge mode disabled' do
    merchant_session = StarkBank::MerchantSession.create(ExampleGenerator.generate_example_merchant_session_json("disabled"))
    merchant_session_purchase_json = ExampleGenerator.generate_example_merchant_session_purchase_challenge_mode_disabled_json()
    merchant_session_purchase = StarkBank::MerchantSession.purchase(
      uuid: merchant_session.uuid,
      payload: merchant_session_purchase_json
    )
    expect(merchant_session_purchase.id).wont_be_nil
  end

  it 'purchase challenge mode enabled' do
    merchant_session_json = ExampleGenerator.generate_example_merchant_session_json("enabled")
    merchant_session = StarkBank::MerchantSession.create(merchant_session_json)
    merchant_session_purchase_json = ExampleGenerator.generate_example_merchant_session_purchase_challenge_mode_enabled_json()
    purchase = StarkBank::MerchantSession.purchase(
      uuid: merchant_session.uuid,
      payload: merchant_session_purchase_json
    )
    expect(purchase.id).wont_be_nil
  end
end
