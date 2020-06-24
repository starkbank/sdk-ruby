# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::Webhook, '#webhook#') do
  it 'query' do
    webhooks = StarkBank::Webhook.query.to_a
    webhooks.each do |webhook|
      expect(webhook.id).wont_be_nil
    end
  end

  it 'create, get and delete' do
    webhook = example
    webhook = StarkBank::Webhook.create(url: webhook.url, subscriptions: webhook.subscriptions)
    get_webhook = StarkBank::Webhook.get(webhook.id)
    expect(webhook.id).must_equal(get_webhook.id)
    delete_webhook = StarkBank::Webhook.delete(webhook.id)
    expect(webhook.id).must_equal(delete_webhook.id)
  end

  def example
    StarkBank::Webhook.new(
      url: 'https://webhook.site/60e9c18e-4b5c-4369-bda1-ab5fcd8e1b29',
      subscriptions: %w[transfer boleto boleto-payment utility-payment]
    )
  end
end
