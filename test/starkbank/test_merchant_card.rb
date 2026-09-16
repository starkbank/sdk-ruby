# frozen_string_literal: false

require_relative('../test_helper.rb')

describe(StarkBank::MerchantCard, '#merchant-card#') do
  it 'query, page and get' do
    cards = StarkBank::MerchantCard.query(limit: 3)
    cards.each do |card|
      expect(card.id).wont_be_nil
    end

    ids = []
    cursor = nil
    (0..1).step(1) do
      page_cards, cursor = StarkBank::MerchantCard.page(limit: 5, cursor: cursor)

      page_cards.each do |card|
        expect(ids).wont_include(card.id)
        ids << card.id
      end
      break if cursor.nil?
    end

    card = StarkBank::MerchantCard.query(limit: 1).to_a[0]
    get_card = StarkBank::MerchantCard.get(card.id)
    expect(get_card.id).must_equal(card.id)
  end
end
