# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::Boleto, '#boleto#') do
  it 'query' do
    boletos = StarkBank::Boleto.query(limit: 10, status: 'paid', before: DateTime.now).to_a
    expect(boletos.length).must_equal(10)
    boletos.each do |boleto|
      expect(boleto.id).wont_be_nil
      expect(boleto.status).must_equal('paid')
    end
  end

  it 'create, get, get_pdf and delete' do
    boleto = StarkBank::Boleto.create([ExampleGenerator.boleto_example])[0]
    get_boleto = StarkBank::Boleto.get(boleto.id)
    expect(boleto.id).must_equal(get_boleto.id)
    pdf = StarkBank::Boleto.pdf(boleto.id, layout: 'booklet')
    File.binwrite('boleto.pdf', pdf)
    delete_boleto = StarkBank::Boleto.delete(boleto.id)
    expect(boleto.id).must_equal(delete_boleto.id)
  end
end
