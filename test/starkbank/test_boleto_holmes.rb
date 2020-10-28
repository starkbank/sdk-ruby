# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::BoletoHolmes, '#holmes#') do
  it 'query' do
    holmes = StarkBank::BoletoHolmes.query(limit: 10, status: 'solved', before: DateTime.now).to_a
    expect(holmes.length).must_equal(10)
    holmes.each do |sherlock|
      expect(sherlock.id).wont_be_nil
      expect(sherlock.status).must_equal('solved')
    end
  end

  it 'create and get' do
    boleto = StarkBank::Boleto.create([ExampleGenerator.boleto_example])[0]
    holmes = StarkBank::BoletoHolmes.create([StarkBank::BoletoHolmes.new(boleto_id: boleto.id)])
    sherlock = holmes[0]
    expect(sherlock.id).wont_be_nil
    get_sherlock = StarkBank::BoletoHolmes.get(sherlock.id)
    expect(sherlock.id).must_equal(get_sherlock.id)
  end
end
