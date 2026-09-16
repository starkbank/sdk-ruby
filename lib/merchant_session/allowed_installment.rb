# frozen_string_literal: true

require_relative('../utils/rest')

module StarkBank
  class MerchantSession
    # # MerchantSession::AllowedInstallment object
    #
    # The MerchantSession::AllowedInstallment object is used to define the amount/installment-count combinations
    # that a MerchantSession will allow a MerchantSession::Purchase to be created with.
    #
    # ## Parameters (required):
    # - total_amount [integer]: total purchase amount that will be allowed to be used with a specific installment count. ex: 100
    # - count [integer]: number of installments allowed. ex: 1
    class AllowedInstallment < StarkCore::Utils::SubResource
      attr_reader :total_amount, :count
      def initialize(total_amount:, count:)
        @total_amount = total_amount
        @count = count
      end

      def self.parse_allowed_installments(allowed_installments)
        resource_maker = StarkBank::MerchantSession::AllowedInstallment.resource[:sub_resource_maker]
        return [] if allowed_installments.nil?

        parsed_allowed_installments = []
        allowed_installments.each do |allowed_installment|
          unless allowed_installment.is_a? AllowedInstallment
            allowed_installment = StarkCore::Utils::API.from_api_json(resource_maker, allowed_installment)
          end
          parsed_allowed_installments << allowed_installment
        end
        return parsed_allowed_installments
      end

      def self.resource
        {
          sub_resource_name: 'AllowedInstallment',
          sub_resource_maker: proc { |json|
            AllowedInstallment.new(
              total_amount: json['total_amount'],
              count: json['count']
            )
          }
        }
      end
    end
  end
end
