# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::BrcodePreview, '#brcode-preview#') do
  it 'query' do
    previews = StarkBank::BrcodePreview.query(brcodes: ["00020126580014br.gov.bcb.pix013635719950-ac93-4bab-8ad6-56d7fb63afd252040000530398654040.005802BR5915Stark Bank S.A.6009Sao Paulo62070503***6304AA26"]).to_a
    expect(previews.length).must_equal(1)
    previews.each do |preview|
      expect(preview.amount).wont_be_nil
    end
  end
end
