# frozen_string_literal: true

require_relative('../utils/rest')


module StarkBank
  class BrcodePayment
    # # BrcodePayment::Rule object
    #
    # The BrcodePayment::Rule object modifies the behavior of BrcodePayment objects when passed as an argument upon their creation.
    #
    # ## Parameters (required):
    # - key [string]: Rule to be customized, describes what BrcodePayment behavior will be altered. ex: "resendingLimit"
    # - value [integer]: Value of the rule. ex: 5
    class Rule < StarkCore::Utils::SubResource
      attr_reader :key, :value
      def initialize(key:, value:)
        @key = key
        @value = value
      end

      def self.parse_rules(rules)
        resource_maker = StarkBank::BrcodePayment::Rule.resource[:resource_maker]
        return rules if rules.nil?

        parsed_rules = []
        rules.each do |rule|
          unless rule.is_a? Rule
            rule = StarkCore::Utils::API.from_api_json(resource_maker, rule)
          end
          parsed_rules << rule
        end
        return parsed_rules
      end

      def self.resource
      {
        resource_name: 'Rule',
        resource_maker: proc { |json|
          Rule.new(
            key: json['key'],
            value: json['value']
          )
        }
      }
      end
    end
  end
end
