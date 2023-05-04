# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')


describe(StarkBank::CorporateCard, '#corporate-card#') do
  it 'query' do
    cards = StarkBank::CorporateCard.query(limit: 100, expand: ['rules'])

    cards.each do |card|
      expect(card.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    (0..1).step(1) do
      cards, cursor = StarkBank::CorporateCard.page(limit: 1, cursor: cursor)

      cards.each do |invoice|
        expect(ids).wont_include(invoice.id)
        ids << invoice.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(2)
  end

  it 'query and get' do
    card = StarkBank::CorporateCard.query(limit: 1).first

    card = StarkBank::CorporateCard.get(card.id)
    expect(card.id).wont_be_nil
  end

  it 'create, update and delete' do
    card = StarkBank::CorporateCard.create(card: ExampleGenerator.corporatecard_example, expand: ['securityCode'])

    card = StarkBank::CorporateCard.update(card.id, display_name: 'Updated name')
    expect(card.display_name).must_equal('Updated name')

    card = StarkBank::CorporateCard.cancel(card.id)
    expect(card.status).must_equal('canceled')
  end
end
