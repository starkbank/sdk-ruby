# frozen_string_literal: true

require_relative('../../starkcore/lib/starkcore')
require_relative('../utils/rest')

module StarkBank
  class PaymentPreview
    # # BrcodePreview object
    #
    # A BrcodePreview is used to get information from a BR Code you received before confirming the payment.
    #
    # ## Attributes (return-only):
    # - status [string]: Payment status. ex: 'active', 'paid', 'canceled' or 'unknown'
    # - name [string]: Payment receiver name. ex: 'Tony Stark'
    # - tax_id [string]: Payment receiver tax ID. ex: '012.345.678-90'
    # - bank_code [string]: Payment receiver bank code. ex: '20018183'
    # - branch_code [string]: Payment receiver branch code. ex: '0001'
    # - account_number [string]: Payment receiver account number. ex: '1234567'
    # - account_type [string]: Payment receiver account type. ex: 'checking'
    # - allow_change [bool]: If True, the payment is able to receive amounts that are different from the nominal one. ex: True or False
    # - amount [integer]: Value in cents that this payment is expecting to receive. If 0, any value is accepted. ex: 123 (= R$1,23)
    # - nominal_amount [integer]: Original value in cents that this payment was expecting to receive without the discounts, fines, etc.. If 0, any value is accepted. ex: 123 (= R$1,23)
    # - interest_amount [integer]: Current interest value in cents that this payment is charging. If 0, any value is accepted. ex: 123 (= R$1,23)
    # - fine_amount [integer]: Current fine value in cents that this payment is charging. ex: 123 (= R$1,23)
    # - reduction_amount [integer]: Current value reduction value in cents that this payment is expecting. ex: 123 (= R$1,23)
    # - discount_amount [integer]: Current discount value in cents that this payment is expecting. ex: 123 (= R$1,23)
    # - reconciliation_id [string]: Reconciliation ID linked to this payment. ex: 'txId', 'payment-123'
    class BrcodePreview < StarkCore::Utils::SubResource
      attr_reader :status, :name, :tax_id, :bank_code, :branch_code, :account_number, :account_type, :allow_change, :amount, :nominal_amount, :interest_amount, :fine_amount, :reduction_amount, :discount_amount, :reconciliation_id
      def initialize(status:, name:, tax_id:, bank_code:, branch_code:, account_number:, account_type:, allow_change:, amount:, nominal_amount:, interest_amount:, fine_amount:, reduction_amount:, discount_amount:, reconciliation_id:)
        @status = status
        @name = name
        @tax_id = tax_id
        @bank_code = bank_code
        @branch_code = branch_code
        @account_number = account_number
        @account_type = account_type
        @allow_change = allow_change
        @amount = amount
        @nominal_amount = nominal_amount
        @interest_amount = interest_amount
        @fine_amount = fine_amount
        @reduction_amount = reduction_amount
        @discount_amount = discount_amount
        @reconciliation_id = reconciliation_id
      end

      def self.resource
        {
          resource_name: 'BrcodePreview',
          resource_maker: proc { |json|
            BrcodePreview.new(
              status: json['status'],
              name: json['name'],
              tax_id: json['tax_id'],
              bank_code: json['bank_code'],
              branch_code: json['branch_code'],
              account_number: json['account_number'],
              account_type: json['account_type'],
              allow_change: json['allow_change'],
              amount: json['amount'],
              nominal_amount: json['nominal_amount'],
              interest_amount: json['interest_amount'],
              fine_amount: json['fine_amount'],
              reduction_amount: json['reduction_amount'],
              discount_amount: json['discount_amount'],
              reconciliation_id: json['reconciliation_id']
            )
          }
        }
      end
    end
  end
end
