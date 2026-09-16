# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::MerchantPurchase, '#merchant-purchase#') do
  it 'create' do
    purchases = StarkBank::MerchantPurchase.query(status: 'confirmed', limit: 1)
    purchases.each do |purchase|
      created = StarkBank::MerchantPurchase.create(ExampleGenerator.merchant_purchase_example(purchase.card_id))
      expect(created.id).wont_be_nil
    end
  end

  it 'query, page and get' do
    purchases = StarkBank::MerchantPurchase.query(limit: 3)
    purchases.each do |purchase|
      expect(purchase.id).wont_be_nil
    end

    ids = []
    cursor = nil
    (0..1).step(1) do
      page_purchases, cursor = StarkBank::MerchantPurchase.page(limit: 5, cursor: cursor)

      page_purchases.each do |purchase|
        expect(ids).wont_include(purchase.id)
        ids << purchase.id
      end
      break if cursor.nil?
    end

    purchase = StarkBank::MerchantPurchase.query(limit: 1).to_a[0]
    get_purchase = StarkBank::MerchantPurchase.get(purchase.id)
    expect(get_purchase.id).must_equal(purchase.id)
  end

  it 'update' do
    purchases = StarkBank::MerchantPurchase.query(limit: 1, status: 'confirmed')
    purchases.each do |purchase|
      next if purchase.amount.zero?

      updated = StarkBank::MerchantPurchase.update(purchase.id, status: 'reversed', amount: 0)
      expect(updated.id).wont_be_nil
    end
  end
end
