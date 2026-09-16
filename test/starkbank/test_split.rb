# frozen_string_literal: false

require_relative('../test_helper.rb')

describe(StarkBank::Split, '#split#') do
  it 'query, page and get' do
    splits = StarkBank::Split.query(limit: 3)
    splits.each do |split|
      expect(split.id).wont_be_nil
    end

    ids = []
    cursor = nil
    (0..1).step(1) do
      page_splits, cursor = StarkBank::Split.page(limit: 5, cursor: cursor)

      page_splits.each do |split|
        expect(ids).wont_include(split.id)
        ids << split.id
      end
      break if cursor.nil?
    end

    split = StarkBank::Split.query(limit: 1).to_a[0]
    get_split = StarkBank::Split.get(split.id)
    expect(get_split.id).must_equal(split.id)
  end
end
