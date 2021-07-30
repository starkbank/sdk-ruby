# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::Invoice::Log, '#invoice/log#') do
  it 'query logs' do
    logs = StarkBank::Invoice::Log.query(limit: 10, types: 'paid').to_a
    expect(logs.length).must_equal(10)
    logs.each do |log|
      expect(log.id).wont_be_nil
      expect(log.type).must_equal('paid')
      expect(log.invoice.status).must_equal('paid')
    end
  end

  it 'page' do
    ids = []
    cursor = nil
    logs = nil
    (0..1).step(1) do
      logs, cursor = StarkBank::Invoice::Log.page(limit: 5, cursor: cursor)
      logs.each do |log|
        expect(ids).wont_include(log.id)
        ids << log.id
      end
      break if cursor.nil?
    end
    expect(ids.length).must_equal(10)
  end

  it 'query and get' do
    log = StarkBank::Invoice::Log.query(limit: 1).to_a[0]
    get_log = StarkBank::Invoice::Log.get(log.id)
    expect(log.id).must_equal(get_log.id)
  end

  it 'query and pdf' do
    log = StarkBank::Invoice::Log.query(limit: 1, types: ['reversed']).to_a[0]
    pdf = StarkBank::Invoice::Log.pdf(log.id)
    File.binwrite('invoice_log.pdf', pdf)
  end
end
