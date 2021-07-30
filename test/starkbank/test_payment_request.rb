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

  it 'page' do
    ids = []
    cursor = nil
    payment_requests = nil
    (0..1).step(1) do
      payment_requests, cursor = StarkBank::PaymentRequest.page(center_id: ENV['SANDBOX_CENTER_ID'], limit: 5, cursor: cursor)
      payment_requests.each do |payment_request|
        expect(ids).wont_include(payment_request.id)
        ids << payment_request.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'create' do
    requests = []
    10.times { requests.push(ExampleGenerator.payment_request_example) }
    StarkBank::PaymentRequest.create(requests).each do |request|
      expect(request.id).wont_be_nil
    end
  end
end
