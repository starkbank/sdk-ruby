# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::CorporateHolder, '#corporate-holder#') do
  it 'query' do
    holders = StarkBank::CorporateHolder.query(limit: 5, expand: ['rules'])
    holders.each do |holder|
      expect(holder.id).wont_be_nil
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    (0..1).step(1) do
      holders, cursor = StarkBank::CorporateHolder.page(limit: 5, cursor: cursor)

      holders.each do |invoice|
        expect(ids).wont_include(invoice.id)
        ids << invoice.id
      end
      break if cursor.nil?
    end
  end

  it 'query and get' do
    holder = StarkBank::CorporateHolder.query(limit: 1).first
    holder = StarkBank::CorporateHolder.get(holder.id)
    expect(holder.id).wont_be_nil
  end

  it 'create, update and delete' do
    holder_id = StarkBank::CorporateHolder.create(holders: [ExampleGenerator.corporateholder_example]).first.id

    holder = StarkBank::CorporateHolder.update(holder_id, name: 'Updated name')
    expect(holder.name).must_equal('Updated name')

    holder = StarkBank::CorporateHolder.cancel(holder_id)
    expect(holder.status).must_equal('canceled')
  end
end
