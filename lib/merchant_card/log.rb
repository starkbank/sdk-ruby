require('starkcore')
require_relative('../utils/rest')
require_relative('merchant_card')


module StarkBank
    class MerchantCard
        class Log < StarkCore::Utils::Resource
            attr_reader :id, :created, :type, :errors, :card
            def initialize(id:, created:, type:, errors:, card:)
                super(id)
                @created = StarkCore::Utils::Checks.check_datetime(created)
                @type = type
                @errors = errors
                @card = card
            end

            def self.get(id, user: nil)
                StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
            end

            def self.query(limit: nil, after: nil, before: nil, types: nil, card_ids: nil, user: nil)
                after = StarkCore::Utils::Checks.check_date(after)
                before = StarkCore::Utils::Checks.check_date(before)
                StarkBank::Utils::Rest.get_stream(
                limit: limit,
                after: after,
                before: before,
                types: types,
                card_ids: card_ids,
                user: user,
                **resource
                )
            end

            def self.page(cursor: nil, limit: nil, after: nil, before: nil, types: nil, card_ids: nil, user: nil)
                after = StarkCore::Utils::Checks.check_date(after)
                before = StarkCore::Utils::Checks.check_date(before)
                return StarkBank::Utils::Rest.get_page(
                cursor: cursor,
                limit: limit,
                after: after,
                before: before,
                types: types,
                card_ids: card_ids,
                user: user,
                **resource
                )
            end

            def self.resource
                card_maker = StarkBank::MerchantCard.resource[:resource_maker]
                {
                resource_name: 'MerchantCardLog',
                resource_maker: proc { |json|
                    Log.new(
                    id: json['id'],
                    created: json['created'],
                    type: json['type'],
                    errors: json['errors'],
                    card: StarkCore::Utils::API.from_api_json(card_maker, json['card'])
                    )
                }
                }
            end
        end
    end
end
