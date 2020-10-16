# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::PaymentRequest, '#payment-request#') do
  it 'query' do
    requests = StarkBank::PaymentRequest.query(center_id: ENV['SANDBOX_CENTER_ID'], limit: 10, status: 'pending', before: DateTime.now).to_a
    expect(requests.length).must_equal(10)
    requests.each do |request|
      expect(request.id).wont_be_nil
      expect(request.status).must_equal('pending')
    end
  end

  it 'create' do
    requests = []
    10.times { requests.push(ExampleGenerator.payment_request_example) }
    StarkBank::PaymentRequest.create(requests).each do |request|
      expect(request.id).wont_be_nil
    end
  end
end
