# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::MerchantInstallment, '#merchant_installment#') do
    it 'query' do
        merchant_installments = StarkBank::MerchantInstallment.query(limit: 3).to_a
        merchant_installments.each do |installment|
        merchant_installment = StarkBank::MerchantInstallment.get(installment.id)
        expect(merchant_installment.id).wont_be_nil
        end
    end

    it 'get' do
        merchant_installments = StarkBank::MerchantInstallment.query(limit: 3).to_a
        merchant_installments.each do |installment|
        merchant_installment = StarkBank::MerchantInstallment.get(installment.id)
        expect(merchant_installment.id).wont_be_nil
        end
    end

    it 'page' do
        ids = []
        cursor = nil
        (0..1).step(1) do
        page, cursor = StarkBank::MerchantInstallment.page(limit: 5, cursor: cursor)
        page.each do |entity|
            expect(ids).wont_include(entity.id)
            ids << entity.id
        end
        break if cursor.nil?
        end
        expect(ids.length).must_equal(10)
    end
end
