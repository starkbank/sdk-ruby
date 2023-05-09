module StarkBank
    # Invoice.Rule object
    # The Invoice.Rule object modifies the behavior of Invoice objects when passed as an argument upon their creation.
    ## Parameters (required):
    # - key [string]: Rule to be customized, describes what Invoice behavior will be altered. ex: 'allowedTaxIds'
    # - value [list of string]: Value of the rule. ex: ['012.345.678-90', '45.059.493/0001-73']
    class InvoiceRule < StarkCore::Utils::SubResource
        attr_reader :key, :value
        def initialize(key:, value:)
            @key = key
            @value = value
        end

        def self.parse_rules(rules)
            resource_maker = StarkBank::InvoiceRule.resource[:resource_maker]
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