# frozen_string_literal: true

require_relative('./test_helper.rb')
require('securerandom')

class ExampleGenerator
  def self.invoice_example
    StarkBank::Invoice.new(
      amount: 100_000,
      due: Time.now + 5 * 24 * 3600,
      name: 'Random Company',
      tax_id: '012.345.678-90',
      expiration: 3600 * 2,
      fine: 0.00,
      interest: 0.00,
      descriptions: [
        {
          key: 'product A',
          value: 'R$ 123,00'
        },
        {
          key: 'product B',
          value: 'R$ 223,00'
        },
        {
          key: 'taxes',
          value: 'R$ 122,00'
        }
      ],
      discounts: [
        {
          percentage: 5,
          due: Time.now + 24 * 3600
        },
        {
          percentage: 2.5,
          due: Time.now + 2 * 24 * 3600
        }
      ]
    )
  end

  def self.boleto_example
    StarkBank::Boleto.new(
      amount: 100_000,
      due: Time.now + 5 * 24 * 3600,
      name: 'Random Company',
      street_line_1: 'Rua ABC',
      street_line_2: 'Ap 123',
      district: 'Jardim Paulista',
      city: 'São Paulo',
      state_code: 'SP',
      zip_code: '01234-567',
      tax_id: '012.345.678-90',
      overdue_limit: 10,
      receiver_name: 'Random Receiver',
      receiver_tax_id: '123.456.789-09',
      fine: 0.00,
      interest: 0.00,
      descriptions: [
        {
          text: 'product A',
          amount: 123
        },
        {
          text: 'product B',
          amount: 456
        },
        {
          text: 'product C',
          amount: 789
        }
      ],
      discounts: [
        {
          percentage: 5,
          date: (Time.now + 24 * 3600).to_date
        },
        {
          percentage: 2.5,
          date: (Time.now + 2 * 24 * 3600).to_date
        }
      ]
    )
  end

  def self.webhook_example
    StarkBank::Webhook.new(
      url: "https://webhook.site/#{SecureRandom.uuid}",
      subscriptions: %w[transfer boleto boleto-payment utility-payment boleto-holmes]
    )
  end

  def self.boleto_payment_example(schedule: true)
    StarkBank::BoletoPayment.new(
      line: '34191.09008 61713.957308 71444.640008 2 934300' + rand(1e8 - 1).to_s.rjust(8, '0'),
      scheduled: schedule ? Date.today + 2 : nil,
      description: 'loading a random account',
      tax_id: '20.018.183/0001-80'
    )
  end

  def self.transaction_example
    StarkBank::Transaction.new(
      amount: 50,
      receiver_id: '5768064935133184',
      external_id: SecureRandom.base64,
      description: 'Transferência para Workspace aleatório'
    )
  end

  def self.transfer_example(schedule: false)
    StarkBank::Transfer.new(
      amount: rand(1000),
      name: 'João',
      tax_id: '01234567890',
      bank_code: '01',
      branch_code: '0001',
      account_number: '10000-0',
      scheduled: schedule ? Time.now + 24 * 3600 : nil
    )
  end

  def self.utility_payment_example(schedule: true)
    StarkBank::UtilityPayment.new(
      bar_code: '8366000' + rand(1e5).to_s.rjust(8, '0') + '01380074119002551100010601813',
      scheduled: schedule ? Date.today + 2 : nil,
      description: 'pagando a conta'
    )
  end

  def self.payment_request_example
    payment = create_payment
    due = nil
    unless payment.is_a?(StarkBank::Transaction)
      days = rand(1..10)
      due = Date.today + days
    end
    StarkBank::PaymentRequest.new(payment: payment, center_id: ENV['SANDBOX_CENTER_ID'], due: due)
  end

  def self.create_payment
    option = rand(4)
    case option
    when 0
      transfer_example(schedule: false)
    when 1
      transaction_example
    when 2
      boleto_payment_example(schedule: false)
    when 3
      utility_payment_example(schedule: false)
    else
      raise(ArgumentError, 'Bad random number')
    end
  end
end
