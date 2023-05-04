# frozen_string_literal: true

require_relative('../utils/rest')

module StarkBank
  class CorporateHolder
    # # CorporateHolder::Permission object
    #
    # The CorporateHolder::Permission object modifies the behavior of CorporateHolder objects when passed as an argument upon their creation.
    #
    # ## Parameters (optional):
    # - owner_id [string, default nil]: owner unique id. ex: "5656565656565656"
    # - owner_type [string, default nil]: owner type. ex: "project"
    #
    # ## Attributes (return-only):
    # - owner_email [string]: email address of the owner. ex: "tony@starkbank.com
    # - owner_name [string]: name of the owner. ex: "Tony Stark"
    # - owner_picture_url [string]: Profile picture Url of the owner. ex: "https://storage.googleapis.com/api-ms-workspace-sbx.appspot.com/pictures/member/6227829385592832?20230404164942"
    # - owner_status [string]: current owner status. ex: "active", "blocked", "canceled"
    # - created [DateTime]: creation datetime for the Permission. ex: ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
    class Permission < StarkCore::Utils::SubResource
      attr_reader :owner_email, :owner_id, :owner_name, :owner_picture_url, :owner_status, :owner_type, :created
      def initialize(owner_email: nil, owner_id: nil, owner_name: nil, owner_picture_url: nil, owner_status: nil, owner_type: nil, created: nil)
        @owner_email = owner_email
        @owner_id = owner_id
        @owner_name = owner_name
        @owner_picture_url = owner_picture_url
        @owner_status = owner_status
        @owner_type = owner_type
        @created = StarkCore::Utils::Checks.check_datetime(created)
      end

      def self.parse_permissions(permissions)
        resource_maker = StarkBank::CorporateHolder::Permission.resource[:resource_maker]
        return permissions if permissions.nil?

        parsed_permissions = []
        permissions.each do |permission|
          unless permission.is_a? Permission
            permission = StarkCore::Utils::API.from_api_json(resource_maker, permission)
          end
          parsed_permissions << permission
        end
        return parsed_permissions
      end

      def self.resource
        {
          resource_name: 'Permission',
          resource_maker: proc { |json|
            Permission.new(
              owner_email: json['owner_email'],
              owner_id: json['owner_id'],
              owner_name: json['owner_name'],
              owner_picture_url: json['owner_picture_url'],
              owner_status: json['owner_status'],
              owner_type: json['owner_type'],
              created: json['created'],
            )
          }
        }
      end
    end
  end
end
