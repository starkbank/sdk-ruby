# frozen_string_literal: true

require_relative('case')

module StarkBank
  module Utils
    module API
      def self.build_entity_hash(entity)
        if entity.is_a?(Hash)
          entity_hash = entity
        else
          entity_hash = {}
          entity.instance_variables.each do |key|
            variable = entity.instance_variable_get(key)
            entity_hash[key[1..-1]] = variable.is_a?(StarkBank::Utils::Resource) ? build_entity_hash(variable) : entity.instance_variable_get(key)
          end
        end
        entity_hash
      end

      def self.api_json(entity)
        built_hash = build_entity_hash(entity)
        cast_json_to_api_format(built_hash)
      end

      def self.cast_json_to_api_format(hash)
        entity_hash = {}
        hash.each do |key, value|
          next if value.nil?

          entity_hash[StarkBank::Utils::Case.snake_to_camel(key)] = parse_value(value)
        end
        entity_hash
      end

      def self.parse_value(value)
        return value.strftime('%Y-%m-%d') if value.is_a?(Date)
        return value.strftime('%Y-%m-%dT%H:%M:%S+00:00') if value.is_a?(DateTime) || value.is_a?(Time)
        return cast_json_to_api_format(value) if value.is_a?(Hash)
        return value unless value.is_a?(Array)

        list = []
        value.each do |v|
          list << (v.is_a?(Hash) ? cast_json_to_api_format(v) : v)
        end
        list
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
        kebab.sub!('-attempt', '/attempt')
        kebab
      end

      def self.last_name_plural(resource_name)
        base = last_name(resource_name)

        return base if base[-1].eql?('s')
        return "#{base}s" if base[-2..-1].eql?('ey')
        return "#{base[0...-1]}ies" if base[-1].eql?('y')

        "#{base}s"
      end

      def self.last_name(resource_name)
        StarkBank::Utils::Case.camel_to_kebab(resource_name).split('-').last
      end
    end
  end
end
