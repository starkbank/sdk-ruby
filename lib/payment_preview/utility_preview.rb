# frozen_string_literal: true

require_relative('../utils/sub_resource')
require_relative('../utils/rest')
require_relative('../utils/checks')

module StarkBank
  class PaymentPreview
    # # UtilityPreview object
    #
    # A UtilityPreview is used to get information from a Utility Payment you received before confirming the payment.
    #
    # ## Attributes (return-only):
    # - amount [int]: final amount to be paid. ex: 23456 (= R$ 234.56)
    # - name [string]: beneficiary full name. ex: "Light Company"
    # - description [string]: utility payment description. ex: "Utility Payment - Light Company"
    # - line [string]: Number sequence that identifies the payment. ex: "82660000002 8 44361143007 7 41190025511 7 00010601813 8"
    # - bar_code [string]: Bar code number that identifies the payment. ex: "82660000002443611430074119002551100010601813"
    class UtilityPreview < StarkBank::Utils::SubResource
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
          resource_name: 'UtilityPreview',
          resource_maker: proc { |json|
            UtilityPreview.new(
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
