# frozen_string_literal: true

require_relative('../test_helper.rb')
require('date')

describe(StarkBank::IssPayment, '#iss-payment#') do
  it 'query' do
    payments = StarkBank::IssPayment.query(limit: 10, status: 'success').to_a
    expect(payments.length).must_equal(10)
    payments.each do |payment|
      expect(payment.id).wont_be_nil
      expect(payment.status).must_equal('success')
    end
  end

  it 'create, get, get_pdf and delete' do
    payment = StarkBank::IssPayment.create([example])[0]
    get_payment = StarkBank::IssPayment.get(payment.id)
    expect(payment.id).must_equal(get_payment.id)
    pdf = StarkBank::IssPayment.pdf(payment.id)
    File.binwrite('iss_payment.pdf', pdf)
    delete_payment = StarkBank::IssPayment.delete(payment.id)
    expect(payment.id).must_equal(delete_payment.id)
  end

  def example
    StarkBank::IssPayment.new(
      bar_code: '8366000' + rand(1e5).to_s.rjust(8, '0') + '01380074119002551100010601813',
      scheduled: Date.today + 2,
      description: 'pagando a conta'
    )
  end
end
