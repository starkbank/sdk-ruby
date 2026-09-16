# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::SplitReceiver, '#split-receiver#') do
  it 'create' do
    receivers = StarkBank::SplitReceiver.create([ExampleGenerator.split_receiver_example])
    receivers.each do |receiver|
      expect(receiver.id).wont_be_nil
    end
  end

  it 'query, page and get' do
    receivers = StarkBank::SplitReceiver.query(limit: 3)
    receivers.each do |receiver|
      expect(receiver.id).wont_be_nil
    end

    ids = []
    cursor = nil
    (0..1).step(1) do
      page_receivers, cursor = StarkBank::SplitReceiver.page(limit: 5, cursor: cursor)

      page_receivers.each do |receiver|
        expect(ids).wont_include(receiver.id)
        ids << receiver.id
      end
      break if cursor.nil?
    end

    receiver = StarkBank::SplitReceiver.query(limit: 1).to_a[0]
    get_receiver = StarkBank::SplitReceiver.get(receiver.id)
    expect(get_receiver.id).must_equal(receiver.id)
  end
end
