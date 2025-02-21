require('starkcore')
require_relative('../utils/rest')
require_relative('merchant_installment')


module StarkBank
    class MerchantInstallment
        class Log < StarkCore::Utils::Resource
            attr_reader :id, :created, :type, :errors, :installment
            def initialize(id:, created:, type:, errors:, installment:)
                super(id)
                @created = StarkCore::Utils::Checks.check_datetime(created)
                @type = type
                @errors = errors
                @installment = installment
            end

            def self.get(id, user: nil)
                StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
            end

            def self.query(limit: nil, after: nil, before: nil, types: nil, installment_ids: nil, user: nil)
                after = StarkCore::Utils::Checks.check_date(after)
                before = StarkCore::Utils::Checks.check_date(before)
                StarkBank::Utils::Rest.get_stream(
                limit: limit,
                after: after,
                before: before,
                types: types,
                installment_ids: installment_ids,
                user: user,
                **resource
                )
            end

            def self.page(cursor: nil, limit: nil, after: nil, before: nil, types: nil, installment_ids: nil, user: nil)
                after = StarkCore::Utils::Checks.check_date(after)
                before = StarkCore::Utils::Checks.check_date(before)
                return StarkBank::Utils::Rest.get_page(
                cursor: cursor,
                limit: limit,
                after: after,
                before: before,
                types: types,
                installment_ids: installment_ids,
                user: user,
                **resource
                )
            end

            def self.resource
                installment_maker = StarkBank::MerchantInstallment.resource[:resource_maker]
                {
                resource_name: 'MerchantInstallmentLog',
                resource_maker: proc { |json|
                        Log.new(
                            id: json['id'],
                            created: json['created'],
                            type: json['type'],
                            errors: json['errors'],
                            installment: StarkCore::Utils::API.from_api_json(installment_maker, json['installment'])
                        )
                    }
                }
            end
        end
    end
end
