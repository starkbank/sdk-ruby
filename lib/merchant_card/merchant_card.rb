# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # MerchantCard object
  #
  # Stores information about a card used in an approved purchase, so it can be reused in new purchases
  # without a new MerchantSession.
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when MerchantCard is created. ex: '5656565656565656'
  # - ending [string]: last 4 digits of the card number. ex: '1234'
  # - funding_type [string]: type of funding used. ex: 'credit', 'debit'
  # - holder_name [string]: card holder name. ex: 'Tony Stark'
  # - network [string]: card network flag. ex: 'visa', 'mastercard'
  # - status [string]: current MerchantCard status. ex: 'active', 'expired', 'canceled' or 'blocked'
  # - tags [list of strings]: list of strings for tagging. ex: ['tony', 'stark']
  # - expiration [DateTime]: card expiration datetime. ex: DateTime.new(2032, 3, 10, 10, 30, 0, 0)
  # - created [DateTime]: creation datetime for the MerchantCard. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: latest update datetime for the MerchantCard. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class MerchantCard < StarkCore::Utils::Resource
    attr_reader :id, :ending, :funding_type, :holder_name, :network, :status, :tags, :expiration, :created, :updated
    def initialize(
      id: nil, ending: nil, funding_type: nil, holder_name: nil, network: nil, status: nil, tags: nil,
      expiration: nil, created: nil, updated: nil
    )
      super(id)
      @ending = ending
      @funding_type = funding_type
      @holder_name = holder_name
      @network = network
      @status = status
      @tags = tags
      @expiration = StarkCore::Utils::Checks.check_date_or_datetime(expiration)
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Retrieve a specific MerchantCard
    #
    # Receive a single MerchantCard object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - MerchantCard object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve MerchantCards
    #
    # Receive a generator of MerchantCard objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'active'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of MerchantCard objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
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

    # # Retrieve paged MerchantCards
    #
    # Receive a list of up to 100 MerchantCard objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'active'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of MerchantCard objects with updated attributes
    # - cursor to retrieve the next page of MerchantCard objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
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

    def self.resource
      {
        resource_name: 'MerchantCard',
        resource_maker: proc { |json|
          MerchantCard.new(
            id: json['id'],
            ending: json['ending'],
            funding_type: json['funding_type'],
            holder_name: json['holder_name'],
            network: json['network'],
            status: json['status'],
            tags: json['tags'],
            expiration: json['expiration'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
