# frozen_string_literal: false

require_relative('../test_helper.rb')

describe(StarkBank::MerchantInstallment, '#merchant-installment#') do
  it 'query, page and get' do
    installments = StarkBank::MerchantInstallment.query(limit: 3)
    installments.each do |installment|
      expect(installment.id).wont_be_nil
    end

    ids = []
    cursor = nil
    (0..1).step(1) do
      page_installments, cursor = StarkBank::MerchantInstallment.page(limit: 5, cursor: cursor)

      page_installments.each do |installment|
        expect(ids).wont_include(installment.id)
        ids << installment.id
      end
      break if cursor.nil?
    end

    installment = StarkBank::MerchantInstallment.query(limit: 1).to_a[0]
    get_installment = StarkBank::MerchantInstallment.get(installment.id)
    expect(get_installment.id).must_equal(installment.id)
  end
end
