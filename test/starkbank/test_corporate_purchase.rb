# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::CorporatePurchase, '#corporate-purchase#') do
  it 'query' do
    purchases = StarkBank::CorporatePurchase.query(limit: 5)
    purchases.each do |purchase|
      expect(purchase.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    (0..1).step(1) do
      purchases, cursor = StarkBank::CorporatePurchase.page(limit: 5, cursor: cursor)

      purchases.each do |purchase|
        expect(ids).wont_include(purchase.id)
        ids << purchase.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'query and get' do
    purchase = StarkBank::CorporatePurchase.query(limit: 1).first

    purchase = StarkBank::CorporatePurchase.get(purchase.id)
    expect(purchase.id).wont_be_nil
  end

  it 'parse with right signature' do
    event = StarkBank::CorporatePurchase.parse(
      content: '{"acquirerId": "236090", "amount": 100, "cardId": "5671893688385536", "cardTags": [], "endToEndId": "2fa7ef9f-b889-4bae-ac02-16749c04a3b6", "holderId": "5917814565109760", "holderTags": [], "isPartialAllowed": false, "issuerAmount": 100, "issuerCurrencyCode": "BRL", "merchantAmount": 100, "merchantCategoryCode": "bookStores", "merchantCountryCode": "BRA", "merchantCurrencyCode": "BRL", "merchantFee": 0, "merchantId": "204933612653639", "merchantName": "COMPANY 123", "methodCode": "token", "purpose": "purchase", "score": null, "tax": 0, "walletId": ""}',
      signature: 'MEUCIBxymWEpit50lDqFKFHYOgyyqvE5kiHERi0ZM6cJpcvmAiEA2wwIkxcsuexh9BjcyAbZxprpRUyjcZJ2vBAjdd7o28Q='
    )
    expect(event).wont_be_nil
  end

  it 'parse with wrong signature' do
    begin
      StarkBank::CorporatePurchase.parse(
        content: '{"acquirerId": "236090", "amount": 100, "cardId": "5671893688385536", "cardTags": [], "endToEndId": "2fa7ef9f-b889-4bae-ac02-16749c04a3b6", "holderId": "5917814565109760", "holderTags": [], "isPartialAllowed": false, "issuerAmount": 100, "issuerCurrencyCode": "BRL", "merchantAmount": 100, "merchantCategoryCode": "bookStores", "merchantCountryCode": "BRA", "merchantCurrencyCode": "BRL", "merchantFee": 0, "merchantId": "204933612653639", "merchantName": "COMPANY 123", "methodCode": "token", "purpose": "purchase", "score": null, "tax": 0, "walletId": ""}',
        signature: 'MEUCIQDOpo1j+V40DNZK2URL2786UQK/8mDXon9ayEd8U0/l7AIgYXtIZJBTs8zCRR3vmted6Ehz/qfw1GRut/eYyvf1yOk='
      )
    rescue StarkBank::Error::InvalidSignatureError
    else
      raise(StandardError, 'invalid signature was not detected')
    end
  end

  it 'parse with malformed signature' do
    begin
      StarkBank::CorporatePurchase.parse(
        content: '{"acquirerId": "236090", "amount": 100, "cardId": "5671893688385536", "cardTags": [], "endToEndId": "2fa7ef9f-b889-4bae-ac02-16749c04a3b6", "holderId": "5917814565109760", "holderTags": [], "isPartialAllowed": false, "issuerAmount": 100, "issuerCurrencyCode": "BRL", "merchantAmount": 100, "merchantCategoryCode": "bookStores", "merchantCountryCode": "BRA", "merchantCurrencyCode": "BRL", "merchantFee": 0, "merchantId": "204933612653639", "merchantName": "COMPANY 123", "methodCode": "token", "purpose": "purchase", "score": null, "tax": 0, "walletId": ""}',
        signature: 'something is definitely wrong'
      )
    rescue StarkBank::Error::InvalidSignatureError
    else
      raise(StandardError, 'malformed signature was not detected')
    end
  end

  it 'denied response' do
    response = StarkBank::CorporatePurchase.response(status: "denied", reason: "taxIdMismatch")
    assert !response.nil?
  end

  it 'approved response' do
    response = StarkBank::CorporatePurchase.response(status: "approved")
    assert !response.nil?
  end
end
