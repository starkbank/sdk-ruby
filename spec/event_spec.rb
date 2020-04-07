# frozen_string_literal: true

require('starkbank')
require('user')

RSpec.describe(StarkBank::Event, '#event') do
  context 'at least 101 webhook events' do
    it 'query' do
      events = StarkBank::Event.query(limit: 101).to_a
      expect(events.length).to(eq(101))
      events.each do |event|
        expect(event.id).not_to(be_nil)
        expect(event.log).not_to(be_nil)
      end
    end
  end

  context 'at least one undelivered event' do
    it 'query, get, update and delete' do
      event = StarkBank::Event.query(limit: 1, is_delivered: false).to_a[0]
      expect(event.is_delivered).to(be(false))
      get_event = StarkBank::Event.get(id: event.id)
      expect(event.id).to(eq(get_event.id))
      update_event = StarkBank::Event.update(id: event.id, is_delivered: true)
      expect(update_event.id).to(eq(event.id))
      expect(update_event.is_delivered).to(be(true))
      delete_event = StarkBank::Event.delete(id: event.id)
      expect(delete_event.id).to(eq(event.id))
    end
  end

  context 'no requirements' do
    it 'parse with right signature' do
      event = StarkBank::Event.parse(
        content: '{"event": {"log": {"transfer": {"status": "processing", "updated": "2020-04-03T13:20:33.485644+00:00", "fee": 160, "name": "Lawrence James", "accountNumber": "10000-0", "id": "5107489032896512", "tags": [], "taxId": "91.642.017/0001-06", "created": "2020-04-03T13:20:32.530367+00:00", "amount": 2, "transactionIds": ["6547649079541760"], "bankCode": "01", "branchCode": "0001"}, "errors": [], "type": "sending", "id": "5648419829841920", "created": "2020-04-03T13:20:33.164373+00:00"}, "subscription": "transfer", "id": "6234355449987072", "created": "2020-04-03T13:20:40.784479+00:00"}}',
        signature: 'MEYCIQCmFCAn2Z+6qEHmf8paI08Ee5ZJ9+KvLWSS3ddp8+RF3AIhALlK7ltfRvMCXhjS7cy8SPlcSlpQtjBxmhN6ClFC0Tv6'
      )
      expect(event.log).not_to(be_nil)
    end

    it 'parse with wrong signature' do
      begin
        StarkBank::Event.parse(
          content: '{"event": {"log": {"transfer": {"status": "processing", "updated": "2020-04-03T13:20:33.485644+00:00", "fee": 160, "name": "Lawrence James", "accountNumber": "10000-0", "id": "5107489032896512", "tags": [], "taxId": "91.642.017/0001-06", "created": "2020-04-03T13:20:32.530367+00:00", "amount": 2, "transactionIds": ["6547649079541760"], "bankCode": "01", "branchCode": "0001"}, "errors": [], "type": "sending", "id": "5648419829841920", "created": "2020-04-03T13:20:33.164373+00:00"}, "subscription": "transfer", "id": "6234355449987072", "created": "2020-04-03T13:20:40.784479+00:00"}}',
          signature: 'MEUCIQDOpo1j+V40DNZK2URL2786UQK/8mDXon9ayEd8U0/l7AIgYXtIZJBTs8zCRR3vmted6Ehz/qfw1GRut/eYyvf1yOk='
        )
        StarkBank::Event.parse(
          content: '{"event": {"log": {"transfer": {"status": "processing", "updated": "2020-04-03T13:20:33.485644+00:00", "fee": 160, "name": "Lawrence James", "accountNumber": "10000-0", "id": "5107489032896512", "tags": [], "taxId": "91.642.017/0001-06", "created": "2020-04-03T13:20:32.530367+00:00", "amount": 2, "transactionIds": ["6547649079541760"], "bankCode": "01", "branchCode": "0001"}, "errors": [], "type": "sending", "id": "5648419829841920", "created": "2020-04-03T13:20:33.164373+00:00"}, "subscription": "transfer", "id": "6234355449987072", "created": "2020-04-03T13:20:40.784479+00:00"}}',
          signature: 'MEUCIQDOpo1j+V40DNZK2URL2786UQK/8mDXon9ayEd8U0/l7AIgYXtIZJBTs8zCRR3vmted6Ehz/qfw1GRut/eYyvf1yOk='
        )
      rescue StarkBank::Error::InvalidSignatureError
      else
        raise(StandardError, 'invalid signature was not detected')
      end
    end
  end
end
