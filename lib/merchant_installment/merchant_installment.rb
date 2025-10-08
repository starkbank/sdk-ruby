require 'starkcore'
require_relative '../utils/rest'


module StarkBank
    class MerchantInstallment < StarkCore::Utils::Resource
        attr_reader :amount, :created, :due, :fee, :fundingType, :id, :network, :purchaseId, :status, :tags, :transactionIds, :updated

        def initialize(amount:, fundingType:, purchaseId:, due:, id: nil, created: nil, fee: nil, network: nil, status: nil, tags: nil, transactionIds: nil, updated: nil)
            super(id)
            @amount = amount
            @fundingType = fundingType
            @purchaseId = purchaseId
            @due = due
            @created = StarkCore::Utils::Checks.check_datetime(created)
            @fee = fee
            @network = network
            @status = status
            @tags = tags
            @transactionIds = transactionIds
            @updated = StarkCore::Utils::Checks.check_datetime(updated)
        end

        def self.resource
            {
                resource_name: 'MerchantInstallment',
                resource_maker: proc { |json|
                    MerchantInstallment.new(
                        amount: json['amount'],
                        fundingType: json['fundingType'],
                        purchaseId: json['purchaseId'],
                        due: json['due'],
                        id: json['id'],
                        created: json['created'],
                        fee: json['fee'],
                        network: json['network'],
                        status: json['status'],
                        tags: json['tags'],
                        transactionIds: json['transactionIds'],
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
    end
end
