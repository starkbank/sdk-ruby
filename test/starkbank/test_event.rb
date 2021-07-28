# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::Event, '#event#') do
  it 'query' do
    events = StarkBank::Event.query(limit: 101).to_a
    expect(events.length).must_equal(101)
    events.each do |event|
      expect(event.id).wont_be_nil
      expect(event.log).wont_be_nil
    end
  end

  it 'query and attempt' do
    events = StarkBank::Event.query(limit: 2, is_delivered: false).to_a
    expect(events.length).must_equal(2)
    events.each do |event|
      expect(event.id).wont_be_nil
      expect(event.log).wont_be_nil
      attempts = StarkBank::Event::Attempt.query(event_ids: [event.id], limit: 1).to_a
      attempts.each do |attempt|
        attempt_get = StarkBank::Event::Attempt.get(attempt.id)
        expect(attempt_get.id).must_equal(attempt.id)
      end
    end
  end

  it 'query, get, update and delete' do
    event = StarkBank::Event.query(limit: 100, is_delivered: false).to_a.sample
    expect(event.is_delivered).must_equal(false)
    get_event = StarkBank::Event.get(event.id)
    expect(event.id).must_equal(get_event.id)
    update_event = StarkBank::Event.update(event.id, is_delivered: true)
    expect(update_event.id).must_equal(event.id)
    expect(update_event.is_delivered).must_equal(true)
    delete_event = StarkBank::Event.delete(event.id)
    expect(delete_event.id).must_equal(event.id)
  end

  it 'parse with right signature' do
    _no_cache_event = StarkBank::Event.parse(
      content: '{"event": {"log": {"transfer": {"status": "processing", "updated": "2020-04-03T13:20:33.485644+00:00", "fee": 160, "name": "Lawrence James", "accountNumber": "10000-0", "id": "5107489032896512", "tags": [], "taxId": "91.642.017/0001-06", "created": "2020-04-03T13:20:32.530367+00:00", "amount": 2, "transactionIds": ["6547649079541760"], "bankCode": "01", "branchCode": "0001"}, "errors": [], "type": "sending", "id": "5648419829841920", "created": "2020-04-03T13:20:33.164373+00:00"}, "subscription": "transfer", "id": "6234355449987072", "created": "2020-04-03T13:20:40.784479+00:00"}}',
      signature: 'MEYCIQCmFCAn2Z+6qEHmf8paI08Ee5ZJ9+KvLWSS3ddp8+RF3AIhALlK7ltfRvMCXhjS7cy8SPlcSlpQtjBxmhN6ClFC0Tv6'
    )
    event = StarkBank::Event.parse(
      content: '{"event": {"log": {"transfer": {"status": "processing", "updated": "2020-04-03T13:20:33.485644+00:00", "fee": 160, "name": "Lawrence James", "accountNumber": "10000-0", "id": "5107489032896512", "tags": [], "taxId": "91.642.017/0001-06", "created": "2020-04-03T13:20:32.530367+00:00", "amount": 2, "transactionIds": ["6547649079541760"], "bankCode": "01", "branchCode": "0001"}, "errors": [], "type": "sending", "id": "5648419829841920", "created": "2020-04-03T13:20:33.164373+00:00"}, "subscription": "transfer", "id": "6234355449987072", "created": "2020-04-03T13:20:40.784479+00:00"}}',
      signature: 'MEYCIQCmFCAn2Z+6qEHmf8paI08Ee5ZJ9+KvLWSS3ddp8+RF3AIhALlK7ltfRvMCXhjS7cy8SPlcSlpQtjBxmhN6ClFC0Tv6'
    )
    expect(event.log).wont_be_nil
  end

  it 'parse with wrong signature' do
    begin
      StarkBank::Event.parse(
        content: '{"event": {"log": {"transfer": {"status": "processing", "updated": "2020-04-03T13:20:33.485644+00:00", "fee": 160, "name": "Lawrence James", "accountNumber": "10000-0", "id": "5107489032896512", "tags": [], "taxId": "91.642.017/0001-06", "created": "2020-04-03T13:20:32.530367+00:00", "amount": 2, "transactionIds": ["6547649079541760"], "bankCode": "01", "branchCode": "0001"}, "errors": [], "type": "sending", "id": "5648419829841920", "created": "2020-04-03T13:20:33.164373+00:00"}, "subscription": "transfer", "id": "6234355449987072", "created": "2020-04-03T13:20:40.784479+00:00"}}',
        signature: 'MEUCIQDOpo1j+V40DNZK2URL2786UQK/8mDXon9ayEd8U0/l7AIgYXtIZJBTs8zCRR3vmted6Ehz/qfw1GRut/eYyvf1yOk='
      )
    rescue StarkBank::Error::InvalidSignatureError
    else
      raise(StandardError, 'invalid signature was not detected')
    end
  end

  it 'parse with malformed signature' do
    begin
      StarkBank::Event.parse(
        content: '{"event": {"log": {"transfer": {"status": "processing", "updated": "2020-04-03T13:20:33.485644+00:00", "fee": 160, "name": "Lawrence James", "accountNumber": "10000-0", "id": "5107489032896512", "tags": [], "taxId": "91.642.017/0001-06", "created": "2020-04-03T13:20:32.530367+00:00", "amount": 2, "transactionIds": ["6547649079541760"], "bankCode": "01", "branchCode": "0001"}, "errors": [], "type": "sending", "id": "5648419829841920", "created": "2020-04-03T13:20:33.164373+00:00"}, "subscription": "transfer", "id": "6234355449987072", "created": "2020-04-03T13:20:40.784479+00:00"}}',
        signature: 'something is definitely wrong'
      )
    rescue StarkBank::Error::InvalidSignatureError
    else
      raise(StandardError, 'malformed signature was not detected')
    end
  end
end
