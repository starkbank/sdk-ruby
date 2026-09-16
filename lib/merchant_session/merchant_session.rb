# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # MerchantSession object
  #
  # When you initialize a MerchantSession, the entity will not be automatically
  # sent to the Stark Bank API. The 'create' function sends the object
  # to the Stark Bank API and returns the created object.
  #
  # ## Parameters (required):
  # - allowed_funding_types [list of strings]: funding types allowed for the purchase. ex: ['credit', 'debit']
  # - allowed_installments [list of MerchantSession::AllowedInstallment objects]: amount/installment-count combinations allowed for the purchase
  # - expiration [integer]: time in seconds from creation until the session expires; after expiration, no purchase can be created with it. ex: 3600
  #
  # ## Parameters (optional):
  # - allowed_ips [list of strings, default nil]: IP addresses allowed to create a purchase with this session. ex: ['192.168.0.1']
  # - challenge_mode [string, default 'enabled']: whether 3DS holder verification is used. Options: 'enabled', 'disabled'
  # - tags [list of strings, default nil]: list of strings for tagging. All tags will be converted to lowercase. ex: ['tony', 'stark']
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when MerchantSession is created. ex: '5656565656565656'
  # - uuid [string]: unique uuid returned when MerchantSession is created, used to create a MerchantSession::Purchase. ex: '901e71f2447c43c886f58366a5432c4b'
  # - holder_id [string]: unique id of the card holder associated with this session, when applicable.
  # - soft_descriptor [string]: text that will be shown in the holder's bank statement, when applicable.
  # - status [string]: current MerchantSession status. ex: 'created', 'expired'
  # - created [DateTime]: creation datetime for the MerchantSession. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: latest update datetime for the MerchantSession. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class MerchantSession < StarkCore::Utils::Resource
    attr_reader :id, :allowed_funding_types, :allowed_installments, :expiration, :allowed_ips, :challenge_mode, :tags,
                :status, :created, :updated, :uuid, :holder_id, :soft_descriptor
    def initialize(
      allowed_funding_types:, allowed_installments:, expiration:, id: nil, allowed_ips: nil, challenge_mode: nil,
      tags: nil, status: nil, created: nil, updated: nil, uuid: nil, holder_id: nil, soft_descriptor: nil
    )
      super(id)
      @allowed_funding_types = allowed_funding_types
      @allowed_installments = StarkBank::MerchantSession::AllowedInstallment.parse_allowed_installments(allowed_installments)
      @allowed_ips = allowed_ips
      @challenge_mode = challenge_mode
      @expiration = expiration
      @tags = tags
      @status = status
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
      @uuid = uuid
      @holder_id = holder_id
      @soft_descriptor = soft_descriptor
    end

    # # Create a MerchantSession
    #
    # Send a MerchantSession object for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - session [MerchantSession object]: MerchantSession object to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - MerchantSession object with updated attributes
    def self.create(session, user: nil)
      StarkBank::Utils::Rest.post_single(entity: session, user: user, **resource)
    end

    # # Retrieve a specific MerchantSession
    #
    # Receive a single MerchantSession object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - MerchantSession object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve MerchantSessions
    #
    # Receive a generator of MerchantSession objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'created'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - holder_id [string, default nil]: filter for sessions belonging to a specific card holder. ex: '5656565656565656'
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of MerchantSession objects with updated attributes
    def self.query(limit: nil, status: nil, tags: nil, ids: nil, after: nil, before: nil, holder_id: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        status: status,
        tags: tags,
        ids: ids,
        after: after,
        before: before,
        holder_id: holder_id,
        user: user,
        **resource
      )
    end

    # # Retrieve paged MerchantSessions
    #
    # Receive a list of up to 100 MerchantSession objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 35
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'created'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - holder_id [string, default nil]: filter for sessions belonging to a specific card holder. ex: '5656565656565656'
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of MerchantSession objects with updated attributes
    # - cursor to retrieve the next page of MerchantSession objects
    def self.page(cursor: nil, limit: nil, status: nil, tags: nil, ids: nil, after: nil, before: nil, holder_id: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        status: status,
        tags: tags,
        ids: ids,
        after: after,
        before: before,
        holder_id: holder_id,
        user: user,
        **resource
      )
    end

    # # Create a MerchantSession::Purchase
    #
    # Send a MerchantSession::Purchase object linked to a previously created MerchantSession, identified by its uuid, for creation in the Stark Bank API.
    # Depending on the MerchantSession's allowed_funding_types and 3DS configuration, the billing and card holder fields on the MerchantSession::Purchase
    # (card_expiration, card_number, card_security_code, holder_name, holder_email, holder_phone, holder_id, billing_country_code, billing_city,
    # billing_state_code, billing_street_line_1, billing_street_line_2, billing_zip_code) and the 3DS metadata may be conditionally required.
    #
    # ## Parameters (required):
    # - uuid [string]: MerchantSession unique uuid returned on creation. ex: '901e71f2447c43c886f58366a5432c4b'
    # - purchase [MerchantSession::Purchase object]: MerchantSession::Purchase object to be created against this session
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - MerchantSession::Purchase object with updated attributes
    def self.purchase(uuid, purchase, user: nil)
      StarkBank::Utils::Rest.post_sub_resource(
        id: uuid,
        entity: purchase,
        user: user,
        resource_name: resource[:resource_name],
        sub_resource_maker: StarkBank::MerchantSession::Purchase.resource[:resource_maker],
        sub_resource_name: StarkBank::MerchantSession::Purchase.resource[:resource_name]
      )
    end

    def self.resource
      {
        resource_name: 'MerchantSession',
        resource_maker: proc { |json|
          MerchantSession.new(
            id: json['id'],
            allowed_funding_types: json['allowed_funding_types'],
            allowed_installments: json['allowed_installments'],
            expiration: json['expiration'],
            allowed_ips: json['allowed_ips'],
            challenge_mode: json['challenge_mode'],
            tags: json['tags'],
            status: json['status'],
            created: json['created'],
            updated: json['updated'],
            uuid: json['uuid'],
            holder_id: json['holder_id'],
            soft_descriptor: json['soft_descriptor']
          )
        }
      }
    end
  end
end
