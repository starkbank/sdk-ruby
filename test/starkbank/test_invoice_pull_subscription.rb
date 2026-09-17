# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::InvoicePullSubscription, '#invoice-pull-subscription#') do
  it 'query' do
    subscriptions = StarkBank::InvoicePullSubscription.query(limit: 10).to_a
    subscriptions.each do |subscription|
      expect(subscription.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    (0..1).step(1) do
      subscriptions, cursor = StarkBank::InvoicePullSubscription.page(limit: 5, cursor: cursor)
      subscriptions.each do |subscription|
        expect(ids).wont_include(subscription.id)
        ids << subscription.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'query and get' do
    subscription = StarkBank::InvoicePullSubscription.query(limit: 1).to_a[0]

    subscription = StarkBank::InvoicePullSubscription.get(subscription.id)
    expect(subscription.id).wont_be_nil
  end

  it 'create and cancel' do
    example = ExampleGenerator.invoice_pull_subscription_example
    subscription = StarkBank::InvoicePullSubscription.create([example])[0]
    expect(subscription.id).wont_be_nil
    expect(subscription.end).must_equal(example.end)

    canceled_subscription = StarkBank::InvoicePullSubscription.cancel(subscription.id)
    expect(canceled_subscription.id).must_equal(subscription.id)
  end
end
