# frozen_string_literal: false

require_relative('../test_helper.rb')

describe(StarkBank::CorporateCard::Log, '#corporatecard/log#') do
  it 'query logs' do
    logs = StarkBank::CorporateCard::Log.query(limit: 1, types: 'created').to_a

    expect(logs.length).must_equal(1)
    logs.each do |log|
      expect(log.id).wont_be_nil
      expect(log.type).must_equal('created')
      expect(log.card.status).must_equal('active')
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    (0..1).step(1) do
      logs, cursor = StarkBank::CorporateCard::Log.page(limit: 4, cursor: cursor)

      logs.each do |log|
        expect(ids).wont_include(log.id)
        ids << log.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(8)
  end

  it 'query and get' do
    log = StarkBank::CorporateCard::Log.query(limit: 1).to_a[0]

    get_log = StarkBank::CorporateCard::Log.get(log.id)
    expect(log.id).must_equal(get_log.id)
  end

  it 'query params' do
    log = StarkBank::CorporateCard::Log.query(
      limit: 1,
      after: '2022-01-01',
      before: '2022-01-02',
      types: ['canceled'],
      card_ids: ['1']
    ).to_a[0]
    expect(log.nil?)
  end

  it 'page params' do
    log = StarkBank::CorporateCard::Log.page(
      limit: 1,
      after: '2022-01-01',
      before: '2022-01-02',
      types: ['canceled'],
      card_ids: ['1']
    ).to_a[0]
    expect(log.nil?)
  end
end
