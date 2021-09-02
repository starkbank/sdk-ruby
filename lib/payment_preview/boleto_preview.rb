# frozen_string_literal: true

require_relative('../utils/sub_resource')
require_relative('../utils/rest')
require_relative('../utils/checks')

module StarkBank
  class PaymentPreview
    # # BoletoPreview object
    #
    # A BoletoPreview is used to get information from a Boleto payment you received before confirming the payment.
    #
    # ## Attributes (return-only):
    # - status [string]: current boleto status. ex: 'active', 'expired' or 'inactive'
    # - amount [int]: final amount to be paid. ex: 23456 (= R$ 234.56)
    # - discount_amount [int]: discount amount to be paid. ex: 23456 (= R$ 234.56)
    # - fine_amount [int]: fine amount to be paid. ex: 23456 (= R$ 234.56)
    # - interest_amount [int]: interest amount to be paid. ex: 23456 (= R$ 234.56)
    # - due [DateTime or string]: Boleto due date. ex: '2020-04-30'
    # - expiration [DateTime or string]: Boleto expiration date. ex: '2020-04-30'
    # - name [string]: beneficiary full name. ex: 'Anthony Edward Stark'
    # - tax_id [string]: beneficiary tax ID (CPF or CNPJ). ex: '20.018.183/0001-80'
    # - receiver_name [string]: receiver (Sacador Avalista) full name. ex: 'Anthony Edward Stark'
    # - receiver_tax_id [string]: receiver (Sacador Avalista) tax ID (CPF or CNPJ). ex: '20.018.183/0001-80'
    # - payer_name [string]: payer full name. ex: 'Anthony Edward Stark'
    # - payer_tax_id [string]: payer tax ID (CPF or CNPJ). ex: '20.018.183/0001-80'
    # - line [string]: Number sequence that identifies the payment. ex: '34191.09008 63571.277308 71444.640008 5 81960000000062'
    # - bar_code [string]: Bar code number that identifies the payment. ex: '34195819600000000621090063571277307144464000'
    class BoletoPreview < StarkBank::Utils::SubResource
      attr_reader :status, :amount, :discount_amount, :fine_amount, :interest_amount, :due, :expiration, :name, :tax_id, :receiver_name, :receiver_tax_id, :payer_name, :payer_tax_id, :line, :bar_code
      def initialize(status:, amount:, discount_amount:, fine_amount:, interest_amount:, due:, expiration:, name:, tax_id:, receiver_name:, receiver_tax_id:, payer_name:, payer_tax_id:, line:, bar_code:)
        @status = status
        @amount = amount
        @discount_amount = discount_amount
        @fine_amount = fine_amount
        @interest_amount = interest_amount
        @due = StarkBank::Utils::Checks.check_datetime(due)
        @expiration = StarkBank::Utils::Checks.check_datetime(expiration)
        @name = name
        @tax_id = tax_id
        @receiver_name = receiver_name
        @receiver_tax_id = receiver_tax_id
        @payer_name = payer_name
        @payer_tax_id = payer_tax_id
        @line = line
        @bar_code = bar_code
      end

      def self.resource
        {
          resource_name: 'BoletoPreview',
          resource_maker: proc { |json|
            BoletoPreview.new(
              status: json['status'],
              amount: json['amount'],
              discount_amount: json['discount_amount'],
              fine_amount: json['fine_amount'],
              interest_amount: json['interest_amount'],
              due: json['due'],
              expiration: json['expiration'],
              name: json['name'],
              tax_id: json['tax_id'],
              receiver_name: json['receiver_name'],
              receiver_tax_id: json['receiver_tax_id'],
              payer_name: json['payer_name'],
              payer_tax_id: json['payer_tax_id'],
              line: json['line'],
              bar_code: json['bar_code'],
            )
          }
        }
      end
    end
  end
end
