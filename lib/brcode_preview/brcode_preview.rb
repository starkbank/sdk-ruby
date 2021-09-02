# frozen_string_literal: true

require_relative('../utils/resource')
require_relative('../utils/rest')
require_relative('../utils/checks')

module StarkBank
  # # BrcodePreview object
  #
  # A BrcodePreview is used to get information from a BR Code you received to check the informations before paying it.
  #
  # ## Attributes (return-only):
  # - status [string]: Payment status. ex: 'active', 'paid', 'canceled' or 'unknown'
  # - name [string]: Payment receiver name. ex: 'Tony Stark'
  # - tax_id [string]: Payment receiver tax ID. ex: '012.345.678-90'
  # - bank_code [string]: Payment receiver bank code. ex: '20018183'
  # - branch_code [string]: Payment receiver branch code. ex: '0001'
  # - account_number [string]: Payment receiver account number. ex: '1234567'
  # - account_type [string]: Payment receiver account type. ex: 'checking'
  # - allow_change [bool]: If True, the payment is able to receive amounts that are diferent from the nominal one. ex: True or False
  # - amount [integer]: Value in cents that this payment is expecting to receive. If 0, any value is accepted. ex: 123 (= R$1,23)
  # - reconciliation_id [string]: Reconciliation ID linked to this payment. ex: 'txId', 'payment-123'
  class BrcodePreview < StarkBank::Utils::Resource
    attr_reader :status, :name, :tax_id, :bank_code, :branch_code, :account_number, :account_type, :allow_change, :amount, :reconciliation_id
    def initialize(status:, name:, tax_id:, bank_code:, branch_code:, account_number:, account_type:, allow_change:, amount:, reconciliation_id:)
      @status = status
      @name = name
      @tax_id = tax_id
      @bank_code = bank_code
      @branch_code = branch_code
      @account_number = account_number
      @account_type = account_type
      @allow_change = allow_change
      @amount = amount
      @reconciliation_id = reconciliation_id
    end

    # # BrcodePreview is DEPRECATED: Please use PaymentPreview instead.
    # Retrieve BrcodePreviews
    #
    # Receive a generator of BrcodePreview objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - brcodes [list of strings]: List of brcodes to preview. ex: %w[00020126580014br.gov.bcb.pix0136a629532e-7693-4846-852d-1bbff817b5a8520400005303986540510.005802BR5908T'Challa6009Sao Paulo62090505123456304B14A]
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of BrcodePreview objects with updated attributes
    def self.query(limit: nil, brcodes: nil, user: nil)
      warn "[DEPRECATION] `BrcodePreview` is deprecated.  Please use `PaymentPreview` instead."
      StarkBank::Utils::Rest.get_stream(
        user: user,
        limit: nil,
        brcodes: brcodes,
        **resource
      )
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
            reconciliation_id: json['reconciliation_id']
          )
        }
      }
    end
  end
end
