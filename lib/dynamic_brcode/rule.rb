require_relative('../utils/rest')

module StarkBank
  class DynamicBrcode
    # # DynamicBrcode::Rule object
    class Rule < StarkCore::Utils::SubResource
      attr_reader :key, :value
      def initialize(key:, value:)
        @key = key
        @value = value
      end

      def self.parse_rules(rules)
        resource_maker = StarkBank::DynamicBrcode::Rule.resource[:resource_maker]
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
