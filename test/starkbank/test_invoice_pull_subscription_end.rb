# frozen_string_literal: false

require_relative('../test_helper.rb')

describe(StarkBank::InvoicePullSubscription, '#invoice-pull-subscription-end#') do
  def build(**overrides)
    StarkBank::InvoicePullSubscription.new(
      start: '2026-12-01', interval: 'month', pull_mode: 'automatic', pull_retry_limit: 3, type: 'push', **overrides
    )
  end

  it 'accepts end as a keyword and exposes it' do
    expect(build(end: '2026-12-31').end).must_equal(Date.new(2026, 12, 31))
  end

  it 'leaves end nil when it is not informed' do
    expect(build.end).must_be_nil
  end

  it 'sends end to the API' do
    expect(StarkCore::Utils::API.api_json(build(end: '2026-12-31'))['end']).must_equal('2026-12-31')
  end

  it 'reads end from the API response' do
    maker = StarkBank::InvoicePullSubscription.resource[:resource_maker]
    json = { 'id' => '1', 'start' => '2026-12-01', 'interval' => 'month', 'pull_mode' => 'automatic',
             'pull_retry_limit' => 3, 'type' => 'push', 'end' => '2026-12-31' }
    expect(maker.call(json).end).must_equal(Date.new(2026, 12, 31))
  end

  it 'treats an empty end as nil' do
    expect(build(end: '').end).must_be_nil
  end

  it 'reads an empty end from the API response as nil' do
    maker = StarkBank::InvoicePullSubscription.resource[:resource_maker]
    json = { 'id' => '1', 'start' => '2026-12-01', 'interval' => 'month', 'pull_mode' => 'automatic',
             'pull_retry_limit' => 3, 'type' => 'push', 'end' => '' }
    expect(maker.call(json).end).must_be_nil
  end
end
