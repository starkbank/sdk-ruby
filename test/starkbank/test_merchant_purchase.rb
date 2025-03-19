# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::MerchantPurchase, '#merchant_purchase#') do

    it 'create' do
        merchant_purchase_example = ExampleGenerator.merchant_purchase_example
        merchant_purchase = StarkBank::MerchantPurchase.create(merchant_purchase_example)
        expect(merchant_purchase.id).wont_be_nil
    end

    it 'query' do
        merchant_purchases = StarkBank::MerchantPurchase.query(limit: 3).to_a
        merchant_purchases.each do |session|
        merchant_purchase = StarkBank::MerchantPurchase.get(session.id)
        expect(merchant_purchase.id).wont_be_nil
        end
    end

    it 'get' do
        merchant_purchases = StarkBank::MerchantPurchase.query(limit: 3).to_a
        merchant_purchases.each do |session|
        merchant_purchase = StarkBank::MerchantPurchase.get(session.id)
        expect(merchant_purchase.id).wont_be_nil
        end
    end

    it 'page' do
        ids = []
        cursor = nil
        (0..1).step(1) do
        page, cursor = StarkBank::MerchantPurchase.page(limit: 5, cursor: cursor)
        page.each do |entity|
            expect(ids).wont_include(entity.id)
            ids << entity.id
        end
        break if cursor.nil?
        end
        expect(ids.length).must_equal(10)
    end

    it 'update' do
        merchant_purchases = StarkBank::MerchantPurchase.query(status: "paid").to_a
        merchant_purchase_id = merchant_purchases[0].id
        merchant_purchase = StarkBank::MerchantPurchase.update(merchant_purchase_id, { "amount": 0, "status": "reversed" })
        expect(merchant_purchase.id).must_equal(merchant_purchase_id)
    end
end
