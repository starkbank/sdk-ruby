# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::BrcodePreview, '#brcode-preview#') do
  it 'query' do
    previews = StarkBank::BrcodePreview.query(brcodes: ["00020126580014br.gov.bcb.pix0136a629532e-7693-4846-852d-1bbff817b5a8520400005303986540510.005802BR5908T'Challa6009Sao Paulo62090505123456304B14A"]).to_a
    expect(previews.length).must_equal(1)
    previews.each do |preview|
      expect(preview.amount).wont_be_nil
    end
  end
end
