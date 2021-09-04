# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::PaymentPreview, '#payment-preview#') do
  it 'create' do
    previews = [
      StarkBank::PaymentPreview.new(scheduled: (Time.now + 24 * 3600).to_date, id: ExampleGenerator.brcode_payment_example(schedule: false).brcode),
      StarkBank::PaymentPreview.new(id: StarkBank::Boleto.create([ExampleGenerator.boleto_example])[0].line),
      StarkBank::PaymentPreview.new(id: ExampleGenerator.tax_payment_example(schedule: false).bar_code),
      StarkBank::PaymentPreview.new(id: ExampleGenerator.utility_payment_example(schedule: false).bar_code)
    ]
    StarkBank::PaymentPreview.create(previews).each do |preview|
      expect(preview).wont_be_nil
      expect(preview.is_a?(StarkBank::PaymentPreview))
    end
  end
end
