# frozen_string_literal: true

require_relative('../../starkcore/lib/starkcore')
require_relative('invoice')

module StarkBank
    class Invoice
        # # Payment object
        #
        # When an Invoice is paid, its InvoicePayment sub-resource will become available.
        # It carries all the available information about the invoice payment.
        #
        # ## Attributes (return-only):
        # - amount [long]: amount in cents that was paid. ex: 1234 (= R$ 12.34)
        # - name [string]: payer full name. ex: 'Anthony Edward Stark'
        # - tax_id [string]: payer tax ID (CPF or CNPJ). ex: '20.018.183/0001-80'
        # - bank_code [string]: code of the payer bank institution in Brazil. ex: '20018183'
        # - branch_code [string]: payer bank account branch. ex: '1357-9'
        # - account_number [string]: payer bank account number. ex: '876543-2'
        # - account_type [string]: payer bank account type. ex: 'checking', 'savings', 'salary' or 'payment'
        # - end_to_end_id [string]: central bank's unique transaction ID. ex: 'E79457883202101262140HHX553UPqeq'
        # - method [string]: payment method that was used. ex: 'pix'
        class Payment < StarkCore::Utils::SubResource
            attr_reader :name, :tax_id, :bank_code, :branch_code, :account_number, :account_type, :amount, :end_to_end_id, :method
            def initialize(name:, tax_id:, bank_code:, branch_code:, account_number:, account_type:, amount:, end_to_end_id:, method:)
                @name = name
                @tax_id = tax_id
                @bank_code = bank_code
                @branch_code = branch_code
                @account_number = account_number
                @account_type = account_type
                @amount = amount
                @end_to_end_id = end_to_end_id
                @method = method
            end

            def self.resource
                {
                    sub_resource_name: 'Payment',
                    sub_resource_maker: proc { |json|
                        Payment.new(
                            name: json['name'],
                            tax_id: json['tax_id'],
                            bank_code: json['bank_code'],
                            branch_code: json['branch_code'],
                            account_number: json['account_number'],
                            account_type: json['account_type'],
                            amount: json['amount'],
                            end_to_end_id: json['end_to_end_id'],
                            method: json['method']
                        )
                    }
                }
            end
        end
    end
end
