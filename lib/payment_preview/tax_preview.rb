# frozen_string_literal: true

require_relative('../../starkcore/lib/starkcore')
require_relative('../utils/rest')

module StarkBank
  class PaymentPreview
    # # TaxPreview object
    #
    # A TaxPreview is used to get information from a Tax Payment you received before confirming the payment.
    #
    # ## Attributes (return-only):
    # - amount [int]: final amount to be paid. ex: 23456 (= R$ 234.56)
    # - name [string]: beneficiary full name. ex: "Iron Throne"
    # - description [string]: tax payment description. ex: "ISS Payment - Iron Throne"
    # - line [string]: Number sequence that identifies the payment. ex: "85660000006 6 67940064007 5 41190025511 7 00010601813 8"
    # - bar_code [string]: Bar code number that identifies the payment. ex: "85660000006679400640074119002551100010601813"
    class TaxPreview < StarkCore::Utils::SubResource
      attr_reader :amount, :name, :description, :line, :bar_code
      def initialize(amount:, name:, description:, line:, bar_code:)
        @amount = amount
        @name = name
        @description = description
        @line = line
        @bar_code = bar_code
      end

      def self.resource
        {
          resource_name: 'TaxPreview',
          resource_maker: proc { |json|
            TaxPreview.new(
              amount: json['amount'],
              name: json['name'],
              description: json['description'],
              line: json['line'],
              bar_code: json['bar_code']
            )
          }
        }
      end
    end
  end
end
