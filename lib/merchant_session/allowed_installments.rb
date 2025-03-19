require 'starkcore'


module StarkBank
  class AllowedInstallment < StarkCore::Utils::SubResource
    attr_reader :total_amount, :count

    def initialize(total_amount:, count:)
      super()
      @total_amount = total_amount
      @count = count
    end

    def self.resource
      {
        resource_name: 'AllowedInstallment',
        resource_maker: proc { |json|
          AllowedInstallment.new(
            total_amount: json['total_amount'],
            count: json['count']
          )
        }
      }
    end
  end
end
