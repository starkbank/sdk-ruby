require 'starkcore'
require_relative '../utils/rest'
require_relative 'allowed_installments'


module StarkBank
  class MerchantSession < StarkCore::Utils::Resource
    attr_reader :allowed_funding_types, :allowed_installments, :expiration, :allowed_ips, :challenge_mode, :status, :tags, :created, :updated, :uuid

    def initialize(
      allowed_funding_types:, allowed_installments:, expiration:, id: nil, allowed_ips: nil, challenge_mode: nil, created: nil, status: nil, tags: nil, updated: nil, uuid: nil
    )
      super(id)
      @allowed_funding_types = allowed_funding_types
      @allowed_installments = parse_allowed_installments(allowed_installments)
      @allowed_ips = allowed_ips
      @challenge_mode = challenge_mode
      @expiration = expiration
      @status = status
      @tags = tags
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
      @uuid = uuid
    end

    def self.resource
      {
        resource_name: 'MerchantSession',
        resource_maker: proc { |json|
          MerchantSession.new(
            id: json['id'],
            allowed_funding_types: json['allowed_funding_types'],
            allowed_installments: json['allowed_installments'].map { |installment| StarkBank::AllowedInstallment.resource[:resource_maker].call(installment) },
            allowed_ips: json['allowed_ips'],
            challenge_mode: json['challenge_mode'],
            expiration: json['expiration'],
            status: json['status'],
            tags: json['tags'],
            created: json['created'],
            updated: json['updated'],
            uuid: json['uuid']
          )
        }
      }
    end

    def self.create(merchant_session, user: nil)
      StarkBank::Utils::Rest.post_single(entity: merchant_session, user: user, **resource)
    end

    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    def self.query(limit: nil, status: nil, tags: nil, ids: nil, after: nil, before: nil, user: nil)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    def self.page(cursor: nil, limit: nil, status: nil, tags: nil, ids: nil, after: nil, before: nil, user: nil)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    def self.purchase(uuid:, payload:, user: nil)
      StarkBank::Utils::Rest.post_sub_resource(id: uuid, entity: payload, user: user, **resource,  **StarkBank::MerchantSession::Purchase.resource)
    end

    private

    def parse_allowed_installments(allowed_installments)
      return nil if allowed_installments.nil?
      allowed_installments.map do |allowed_installment|
        if allowed_installment.is_a?(StarkBank::AllowedInstallment)
          allowed_installment
        else
          StarkCore::Utils::API.from_api_json(StarkBank::AllowedInstallment.resource, allowed_installment)
        end
      end
    end
  end
end
