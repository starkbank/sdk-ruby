# frozen_string_literal: false

require_relative('../test_helper.rb')

describe(StarkBank::CorporateHolder::Log, '#corporateholder/log#') do
  it 'query logs' do
    logs = StarkBank::CorporateHolder::Log.query(limit: 10, types: 'created').to_a

    expect(logs.length).must_equal(10)
    logs.each do |log|
      expect(log.id).wont_be_nil
      expect(log.type).must_equal('created')
      expect(log.holder.status).must_equal('active')
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    (0..1).step(1) do
      logs, cursor = StarkBank::CorporateHolder::Log.page(limit: 5, cursor: cursor)

      logs.each do |log|
        expect(ids).wont_include(log.id)
        ids << log.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'query and get' do
    log = StarkBank::CorporateHolder::Log.query(limit: 1).to_a[0]

    get_log = StarkBank::CorporateHolder::Log.get(log.id)
    expect(log.id).must_equal(get_log.id)
  end

  it 'query params' do
    log = StarkBank::CorporateHolder::Log.query(
      limit: 1,
      after: '2022-01-01',
      before: '2022-01-02',
      types: ['canceled'],
      holder_ids: ['1']
    ).to_a[0]
    expect(log.nil?)
  end

  it 'page params' do
    log = StarkBank::CorporateHolder::Log.page(
      limit: 1,
      after: '2022-01-01',
      before: '2022-01-02',
      types: ['canceled'],
      holder_ids: ['1']
    ).to_a[0]
    expect(log.nil?)
  end
end
