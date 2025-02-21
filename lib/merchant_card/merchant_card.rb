require 'starkcore'
require_relative '../utils/rest'


module StarkBank
    class MerchantCard < StarkCore::Utils::Resource
        attr_reader :created, :ending, :expiration, :fundingType, :holderName, :id, :network, :status, :tags, :updated

        def initialize(ending:, expiration:, fundingType:, holderName:, id: nil, created: nil, network: nil, status: nil, tags: nil, updated: nil)
            super(id)
            @ending = ending
            @expiration = expiration
            @fundingType = fundingType
            @holderName = holderName
            @created = StarkCore::Utils::Checks.check_datetime(created)
            @network = network
            @status = status
            @tags = tags
            @updated = StarkCore::Utils::Checks.check_datetime(updated)
        end

        def self.resource
            {
                resource_name: 'MerchantCard',
                resource_maker: proc { |json|
                    MerchantCard.new(
                        ending: json['ending'],
                        expiration: json['expiration'],
                        fundingType: json['fundingType'],
                        holderName: json['holderName'],
                        id: json['id'],
                        created: json['created'],
                        network: json['network'],
                        status: json['status'],
                        tags: json['tags'],
                        updated: json['updated']
                    )
                }
            }
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

        def self.page(limit: nil, cursor: nil, status: nil, tags: nil, ids: nil, user: nil)
            StarkBank::Utils::Rest.get_page(
                limit: limit,
                cursor: cursor,
                status: status,
                tags: tags,
                ids: ids,
                user: user,
                **resource
            )
        end
    end
end
