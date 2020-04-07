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
end
