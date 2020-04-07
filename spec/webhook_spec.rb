# frozen_string_literal: true

require('starkbank')
require('user')

RSpec.describe(StarkBank::Webhook, '#webhook') do
  context 'at least 1 webhook' do
    it 'query' do
      webhooks = StarkBank::Webhook.query.to_a
      webhooks.each do |webhook|
        expect(webhook.id).not_to(be_nil)
      end
    end
  end

  context 'no requirements' do
    it 'create, get and delete' do
      webhook = example
      webhook = StarkBank::Webhook.create(url: webhook.url, subscriptions: webhook.subscriptions)
      get_webhook = StarkBank::Webhook.get(id: webhook.id)
      expect(webhook.id).to(eq(get_webhook.id))
      delete_webhook = StarkBank::Webhook.delete(id: webhook.id)
      expect(webhook.id).to(eq(delete_webhook.id))
    end
  end

  def example
    StarkBank::Webhook.new(
      url: 'https://webhook.site/60e9c18e-4b5c-4369-bda1-ab5fcd8e1b29',
      subscriptions: %w[transfer boleto boleto-payment utility-payment]
    )
  end
end
