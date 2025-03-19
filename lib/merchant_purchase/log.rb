require('starkcore')
require_relative('../utils/rest')
require_relative('merchant_purchase')


module StarkBank
    class MerchantPurchase
        class Log < StarkCore::Utils::Resource
            attr_reader :id, :created, :type, :errors, :purchase
            def initialize(id:, created:, type:, errors:, purchase:)
                super(id)
                @created = StarkCore::Utils::Checks.check_datetime(created)
                @type = type
                @errors = errors
                @purchase = purchase
            end

            def self.get(id, user: nil)
                StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
            end

            def self.query(limit: nil, after: nil, before: nil, types: nil, purchase_ids: nil, user: nil)
                after = StarkCore::Utils::Checks.check_date(after)
                before = StarkCore::Utils::Checks.check_date(before)
                StarkBank::Utils::Rest.get_stream(
                limit: limit,
                after: after,
                before: before,
                types: types,
                purchase_ids: purchase_ids,
                user: user,
                **resource
                )
            end

            def self.page(cursor: nil, limit: nil, after: nil, before: nil, types: nil, purchase_ids: nil, user: nil)
                after = StarkCore::Utils::Checks.check_date(after)
                before = StarkCore::Utils::Checks.check_date(before)
                return StarkBank::Utils::Rest.get_page(
                cursor: cursor,
                limit: limit,
                after: after,
                before: before,
                types: types,
                purchase_ids: purchase_ids,
                user: user,
                **resource
                )
            end

            def self.resource
                purchase_maker = StarkBank::MerchantPurchase.resource[:resource_maker]
                {
                resource_name: 'MerchantPurchaseLog',
                resource_maker: proc { |json|
                    Log.new(
                    id: json['id'],
                    created: json['created'],
                    type: json['type'],
                    errors: json['errors'],
                    purchase: StarkCore::Utils::API.from_api_json(purchase_maker, json['purchase'])
                    )
                }
                }
            end
        end
    end
end
