# frozen_string_literal: true

require_relative('case')

module StarkBank
  module Utils
    module API
      def self.api_json(entity)
        if entity.is_a?(Hash)
          entity_hash = entity
        else
          entity_hash = {}
          entity.instance_variables.each do |key|
            entity_hash[key[1..-1]] = entity.instance_variable_get(key)
          end
        end
        cast_json_to_api_format(entity_hash)
      end

      def self.cast_json_to_api_format(hash)
        entity_hash = {}
        hash.each do |key, value|
          next if value.nil?

          value = value.is_a?(Date) || value.is_a?(DateTime) || value.is_a?(Time) ? value.strftime('%Y-%m-%d') : value

          if value.is_a?(Array)
            list = []
            value.each do |v|
              list << (v.is_a?(Hash) ? cast_json_to_api_format(v) : v)
            end
            value = list
          end

          entity_hash[StarkBank::Utils::Case.snake_to_camel(key)] = value
        end
        entity_hash
      end

      def self.from_api_json(resource_maker, json)
        snakes = {}
        json.each do |key, value|
          snakes[StarkBank::Utils::Case.camel_to_snake(key)] = value
        end
        resource_maker.call(snakes)
      end

      def self.endpoint(resource_name)
        kebab = StarkBank::Utils::Case.camel_to_kebab(resource_name)
        kebab.sub!('-log', '/log')
        kebab
      end

      def self.last_name_plural(resource_name)
        "#{last_name(resource_name)}s"
      end

      def self.last_name(resource_name)
        StarkBank::Utils::Case.camel_to_kebab(resource_name).split('-').last
      end
    end
  end
end
