require('starkcore')
require_relative('../utils/rest')
require_relative('merchant_session')


module StarkBank
  class MerchantSession

    class Log < StarkCore::Utils::Resource
      attr_reader :id, :created, :type, :errors, :session
      def initialize(id:, created:, type:, errors:, session:)
        super(id)
        @created = StarkCore::Utils::Checks.check_datetime(created)
        @type = type
        @errors = errors
        @session = session
      end

      def self.get(id, user: nil)
        StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
      end

      def self.query(limit: nil, after: nil, before: nil, types: nil, session_ids: nil, user: nil)
        after = StarkCore::Utils::Checks.check_date(after)
        before = StarkCore::Utils::Checks.check_date(before)
        StarkBank::Utils::Rest.get_stream(
          limit: limit,
          after: after,
          before: before,
          types: types,
          session_ids: session_ids,
          user: user,
          **resource
        )
      end

      def self.page(cursor: nil, limit: nil, after: nil, before: nil, types: nil, session_ids: nil, user: nil)
        after = StarkCore::Utils::Checks.check_date(after)
        before = StarkCore::Utils::Checks.check_date(before)
        return StarkBank::Utils::Rest.get_page(
          cursor: cursor,
          limit: limit,
          after: after,
          before: before,
          types: types,
          session_ids: session_ids,
          user: user,
          **resource
        )
      end

      def self.resource
        session_maker = StarkBank::MerchantSession.resource[:resource_maker]
        {
          resource_name: 'MerchantSessionLog',
          resource_maker: proc { |json|
            Log.new(
              id: json['id'],
              created: json['created'],
              type: json['type'],
              errors: json['errors'],
              session: StarkCore::Utils::API.from_api_json(session_maker, json['session'])
            )
          }
        }
      end
    end
  end
end

