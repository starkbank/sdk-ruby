# frozen_string_literal: true

require('starkcore')

module StarkBank
  module Utils
    module Rest

      def self.get_page(resource_name:, resource_maker:, user:, **query)
        return StarkCore::Utils::Rest.get_page(
          resource_name: resource_name,
          resource_maker: resource_maker,
          sdk_version: StarkBank::SDK_VERSION,
          host: StarkBank::HOST,
          api_version: StarkBank::API_VERSION,
          user: user ? user : StarkBank.user,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          **query
        )
      end

      def self.get_stream(resource_name:, resource_maker:, user:, **query)
        return StarkCore::Utils::Rest.get_stream(
          resource_name: resource_name,
          resource_maker: resource_maker,
          sdk_version: StarkBank::SDK_VERSION,
          host: StarkBank::HOST,
          api_version: StarkBank::API_VERSION,
          user: user ? user : StarkBank.user,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          **query
        )
      end

      def self.get_id(resource_name:, resource_maker:, user:, id:, **query)
        return StarkCore::Utils::Rest.get_id(
          resource_name: resource_name,
          resource_maker: resource_maker,
          sdk_version: StarkBank::SDK_VERSION,
          host: StarkBank::HOST,
          api_version: StarkBank::API_VERSION,
          user: user ? user : StarkBank.user,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          id: id,
          **query
        )
      end

      def self.get_content(resource_name:, resource_maker:, user:, sub_resource_name:, id:, **query)
        return StarkCore::Utils::Rest.get_content(
          resource_name: resource_name,
          resource_maker: resource_maker,
          sdk_version: StarkBank::SDK_VERSION,
          host: StarkBank::HOST,
          api_version: StarkBank::API_VERSION,
          user: user ? user : StarkBank.user,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          sub_resource_name: sub_resource_name, 
          id: id,
          **query
        )
      end

      def self.get_sub_resource(resource_name:, sub_resource_maker:, sub_resource_name:, user:, id:, **query)
        return StarkCore::Utils::Rest.get_sub_resource(
          resource_name: resource_name,
          sub_resource_maker: sub_resource_maker, 
          sub_resource_name: sub_resource_name, 
          sdk_version: StarkBank::SDK_VERSION, 
          host: StarkBank::HOST, 
          api_version: StarkBank::API_VERSION, 
          user: user ? user : StarkBank.user, 
          language: StarkBank.language, 
          timeout: StarkBank.timeout, 
          id: id, 
          **query
        )
      end

      def self.get_sub_resources(resource_name:, sub_resource_maker:, sub_resource_name:, user:, id:, **query)
        return StarkCore::Utils::Rest.get_sub_resource(
          resource_name: resource_name,
          sub_resource_maker: sub_resource_maker, 
          sub_resource_name: sub_resource_name, 
          sdk_version: StarkBank::SDK_VERSION, 
          host: StarkBank::HOST, 
          api_version: StarkBank::API_VERSION, 
          user: user ? user : StarkBank.user, 
          language: StarkBank.language, 
          timeout: StarkBank.timeout, 
          id: id, 
          **query
        )
      end

      def self.post(resource_name:, resource_maker:, user:, entities:, **query)
        return StarkCore::Utils::Rest.post(
          resource_name: resource_name,
          resource_maker: resource_maker,
          sdk_version: StarkBank::SDK_VERSION,
          host: StarkBank::HOST,
          api_version: StarkBank::API_VERSION,
          user: user ? user : StarkBank.user,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          entities: entities,
          **query
        )
      end

      def self.post_single(resource_name:, resource_maker:, user:, entity:)
        return StarkCore::Utils::Rest.post_single(
          resource_name: resource_name,
          resource_maker: resource_maker,
          sdk_version: StarkBank::SDK_VERSION,
          host: StarkBank::HOST,
          api_version: StarkBank::API_VERSION,
          user: user ? user : StarkBank.user,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          entity: entity
        )
      end

      def self.delete_id(resource_name:, resource_maker:, user:, id:)
        return StarkCore::Utils::Rest.delete_id(
          resource_name: resource_name,
          resource_maker: resource_maker,
          sdk_version: StarkBank::SDK_VERSION,
          host: StarkBank::HOST,
          api_version: StarkBank::API_VERSION,
          user: user ? user : StarkBank.user,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          id: id
        )
      end

      def self.patch_id(resource_name:, resource_maker:, user:, id:, **payload)
        return StarkCore::Utils::Rest.patch_id(
          resource_name: resource_name,
          resource_maker: resource_maker,
          sdk_version: StarkBank::SDK_VERSION,
          host: StarkBank::HOST,
          api_version: StarkBank::API_VERSION,
          user: user ? user : StarkBank.user,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          id: id,
          **payload
        )
      end

      def self.get_raw(path:, prefix: nil, raiseException: nil, user: nil, query: nil)
        return StarkCore::Utils::Rest.get_raw(
          host: StarkBank::HOST,
          sdk_version: StarkBank::SDK_VERSION,
          user: user ? user : StarkBank.user,
          path: path,
          api_version: StarkBank::API_VERSION,
          language: StarkBank.language,
          timeout: StarkBank.timeout, 
          prefix: prefix,
          raiseException: raiseException,
          query: query
        )
      end

      def self.post_raw(path:, payload:, query: nil, prefix: nil, raiseException: nil, user:)

        return StarkCore::Utils::Rest.post_raw(
          host: StarkBank::HOST,
          sdk_version: StarkBank::SDK_VERSION,
          user: user ? user : StarkBank.user,
          path: path,
          payload: payload,
          api_version: StarkBank::API_VERSION,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          query: query,
          prefix: prefix,
          raiseException: raiseException
        )
      end

      def self.patch_raw(path:, payload:, query: nil, prefix: nil, raiseException: nil, user: nil)
        return StarkCore::Utils::Rest.patch_raw(
          host: StarkBank::HOST,
          sdk_version: StarkBank::SDK_VERSION,
          user: user ? user : StarkBank.user,
          path: path,
          payload: payload,
          api_version: StarkBank::API_VERSION,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          query: query,
          prefix: prefix,
          raiseException: raiseException
        )
      end

      def self.put_raw(path:, payload:, query: nil, prefix: nil, raiseException: nil, user: nil)
        return StarkCore::Utils::Rest.put_raw(
          host: StarkBank::HOST,
          sdk_version: StarkBank::SDK_VERSION,
          user: user ? user : StarkBank.user,
          path: path,
          payload: payload,
          api_version: StarkBank::API_VERSION,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          query: query,
          prefix: prefix,
          raiseException: raiseException
        )
      end

      def self.delete_raw(path:, query: nil, prefix: nil, raiseException: nil, user: nil)
        return StarkCore::Utils::Rest.delete_raw(
          host: StarkBank::HOST,
          sdk_version: StarkBank::SDK_VERSION,
          user: user ? user : StarkBank.user,
          path: path,
          api_version: StarkBank::API_VERSION,
          language: StarkBank.language,
          timeout: StarkBank.timeout,
          query: query,
          prefix: prefix,
          raiseException: raiseException
        )
      end
    end
  end
end
