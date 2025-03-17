require_relative('../utils/rest')

module StarkBank
  class DynamicBrcode
    # # DynamicBrcode::Rule object
    #
    # The DynamicBrcode.Rule object modifies the behavior of DynamicBrcode objects when passed as an argument upon their creation.
    #
    # ## Parameters (required):
    # - key [string]: Rule to be customized, describes what DynamicBrcode behavior will be altered. ex: "allowedTaxIds"
    # - value [list of strings]: Value of the rule. ex: ["012.345.678-90", "45.059.493/0001-73"]
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
