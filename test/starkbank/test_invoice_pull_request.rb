# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::InvoicePullRequest, '#invoice-pull-request#') do
  it 'query' do
    requests = StarkBank::InvoicePullRequest.query(limit: 10).to_a
    requests.each do |request|
      expect(request.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    (0..1).step(1) do
      requests, cursor = StarkBank::InvoicePullRequest.page(limit: 5, cursor: cursor)
      requests.each do |request|
        expect(ids).wont_include(request.id)
        ids << request.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'query and get' do
    request = StarkBank::InvoicePullRequest.query(limit: 1).to_a[0]

    request = StarkBank::InvoicePullRequest.get(request.id)
    expect(request.id).wont_be_nil
  end

  it 'create and cancel' do
    invoice = StarkBank::Invoice.create([ExampleGenerator.invoice_example])[0]
    subscription = StarkBank::InvoicePullSubscription.create([ExampleGenerator.invoice_pull_subscription_example])[0]

    example = ExampleGenerator.invoice_pull_request_example(subscription_id: subscription.id, invoice_id: invoice.id)
    request = StarkBank::InvoicePullRequest.create([example])[0]
    expect(request.id).wont_be_nil

    canceled_request = StarkBank::InvoicePullRequest.cancel(request.id)
    expect(canceled_request.id).must_equal(request.id)
  end
end
