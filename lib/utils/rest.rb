# frozen_string_literal: true

require_relative('request')
require_relative('api')

module StarkBank
  module Utils
    module Rest
      def self.get_list(resource_name:, resource_maker:, user: nil, **query)
        limit = query[:limit]
        query[:limit] = limit.nil? ? limit : [limit, 100].min

        Enumerator.new do |enum|
          loop do
            json = StarkBank::Utils::Request.fetch(
              method: 'GET',
              path: StarkBank::Utils::API.endpoint(resource_name),
              query: query,
              user: user
            ).json
            entities = json[StarkBank::Utils::API.last_name_plural(resource_name)]

            entities.each do |entity|
              enum << StarkBank::Utils::API.from_api_json(resource_maker, entity)
            end

            unless limit.nil?
              limit -= 100
              query[:limit] = [limit, 100].min
            end

            cursor = json['cursor']
            query['cursor'] = cursor

            break if cursor.nil? || (!limit.nil? && limit <= 0)
          end
        end
      end

      def self.get_id(resource_name:, resource_maker:, id:, user: nil)
        json = StarkBank::Utils::Request.fetch(
          method: 'GET',
          path: "#{StarkBank::Utils::API.endpoint(resource_name)}/#{id}",
          user: user
        ).json
        entity = json[StarkBank::Utils::API.last_name(resource_name)]
        StarkBank::Utils::API.from_api_json(resource_maker, entity)
      end

      def self.get_pdf(resource_name:, resource_maker:, id:, user: nil)
        StarkBank::Utils::Request.fetch(
          method: 'GET',
          path: "#{StarkBank::Utils::API.endpoint(resource_name)}/#{id}/pdf",
          user: user
        ).content
      end

      def self.post(resource_name:, resource_maker:, entities:, user: nil)
        jsons = []
        entities.each do |entity|
          jsons << StarkBank::Utils::API.api_json(entity)
        end
        payload = { StarkBank::Utils::API.last_name_plural(resource_name) => jsons }
        json = StarkBank::Utils::Request.fetch(
          method: 'POST',
          path: StarkBank::Utils::API.endpoint(resource_name),
          payload: payload,
          user: user
        ).json
        returned_jsons = json[StarkBank::Utils::API.last_name_plural(resource_name)]
        entities = []
        returned_jsons.each do |returned_json|
          entities << StarkBank::Utils::API.from_api_json(resource_maker, returned_json)
        end
        entities
      end

      def self.post_single(resource_name:, resource_maker:, entity:, user: nil)
        json = StarkBank::Utils::Request.fetch(
          method: 'POST',
          path: StarkBank::Utils::API.endpoint(resource_name),
          payload: StarkBank::Utils::API.api_json(entity),
          user: user
        ).json
        entity_json = json[StarkBank::Utils::API.last_name(resource_name)]
        StarkBank::Utils::API.from_api_json(resource_maker, entity_json)
      end

      def self.delete_id(resource_name:, resource_maker:, id:, user: nil)
        json = StarkBank::Utils::Request.fetch(
          method: 'DELETE',
          path: "#{StarkBank::Utils::API.endpoint(resource_name)}/#{id}",
          user: user
        ).json
        entity = json[StarkBank::Utils::API.last_name(resource_name)]
        StarkBank::Utils::API.from_api_json(resource_maker, entity)
      end

      def self.patch_id(resource_name:, resource_maker:, id:, user: nil, **payload)
        payload = StarkBank::Utils::API.cast_json_to_api_format(payload)
        json = StarkBank::Utils::Request.fetch(
          method: 'PATCH',
          path: "#{StarkBank::Utils::API.endpoint(resource_name)}/#{id}",
          user: user,
          payload: payload
        ).json
        entity = json[StarkBank::Utils::API.last_name(resource_name)]
        StarkBank::Utils::API.from_api_json(resource_maker, entity)
      end
    end
  end
end
