# frozen_string_literal: true

require_relative('case')

module StarkBank
  module Utils
    module API
      def api_json(entity)
        entity_hash = {}
        entity.instance_variables.each do |key|
          entity_hash[key] = entity.instance_variable_get(key)
        end
        cast_to_json_to_api_format(entity_hash)
      end

      def from_api_json(resource_maker, json)
        snakes = {}
        json.each |key, value| do
          snakes[StarkBank::Utils::Case.camel_to_snake(key)] = value
        end
        resource_maker(snakes)
      end

      def endpoint(resource_name)
        camel_to_kebab(resource_name).sub!('-log', '/log')
      end

      def last_name_plural(resource_name)
        "#{last_name(resource_name)}s"
      end
      
      def last_name(resource_name)
        camel_to_kebab(resource_name).split('-').last
      end

      private

      def cast_to_json_to_api_format(hash)
        entity_hash = {}
        hash.each do |key, value|
          next if value.nil?

          value = value.is_a?(Date) || value.is_a?(DateTime) ? value.strftime('%Y-%m-%d') : value
          entity_hash[StarkBank::Utils::Case.snake_to_camel(key)] = date_to_string(value)
        end
      end
    end
  end
end
