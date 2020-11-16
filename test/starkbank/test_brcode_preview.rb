# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::BrcodePayment, '#brcode-payment#') do
  it 'query' do
    payments = StarkBank::BrcodePayment.query(brcodes: %w[00020126580014br.gov.bcb.pix0136a629532e-7693-4846-852d-1bbff817b5a8520400005303986540510.005802BR5908T'Challa6009Sao Paulo62090505123456304B14A]).to_a
    expect(payments.length).must_equal(1)
    payments.each do |payment|
      expect(payment.amount).wont_be_nil
    end
  end
end
