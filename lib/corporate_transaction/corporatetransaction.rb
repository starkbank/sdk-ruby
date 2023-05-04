# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # CorporateTransaction object
  #
  # The CorporateTransaction objects created in your Workspace to represent each balance shift.
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when CorporateTransaction is created. ex: '5656565656565656'
  # - amount [integer]: CorporateTransaction value in cents. ex: 1234 (= R$ 12.34)
  # - balance [integer]: balance amount of the Workspace at the instant of the Transaction in cents. ex: 200 (= R$ 2.00)
  # - description [string]: CorporateTransaction description. ex: 'Buying food'
  # - source [string]: source of the transaction. ex: 'corporate-purchase/5656565656565656'
  # - tags [string]: list of strings inherited from the source resource. ex: ['tony', 'stark']
  # - created [DateTime]: creation datetime for the CorporateTransaction. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class CorporateTransaction < StarkCore::Utils::Resource
    attr_reader :id, :amount, :balance, :description, :source, :tags, :created

    def initialize(id: nil, amount: nil, balance: nil, description: nil, source: nil, tags: nil, created: nil)
      super(id)
      @amount = amount
      @balance = balance
      @description = description
      @source = source
      @tags = tags
      @created = StarkCore::Utils::Checks.check_datetime(created)
    end

    # # Retrieve a specific CorporateTransaction
    #
    # Receive a single CorporateTransaction object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - CorporateTransaction object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve CorporateTransactions
    #
    # Receive a generator of CorporateTransaction objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - external_ids [list of strings, default nil]: external IDs. ex: ['5656565656565656', '4545454545454545']
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'approved', 'canceled', 'denied', 'confirmed' or 'voided'
    # - ids [list of strings, default nil]: purchase IDs
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of CorporateTransaction objects with updated attributes
    def self.query(tags: nil, external_ids: nil, after: nil, before: nil, status: nil, ids: nil, limit: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        tags: tags,
        external_ids: external_ids,
        after: after,
        before: before,
        status: status,
        ids: ids,
        limit: limit,
        user: user,
        **resource
      )
    end

    # # Retrieve paged CorporateTransactions
    #
    # Receive a list of up to 100 CorporateTransaction objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call.
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - external_ids [list of strings, default nil]: external IDs. ex: ['5656565656565656', '4545454545454545']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'approved', 'canceled', 'denied', 'confirmed' or 'voided'
    # - ids [list of strings, default nil]: purchase IDs
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of CorporateTransactions objects with updated attributes
    # - cursor to retrieve the next page of CorporateTransactions objects
    def self.page(cursor: nil, tags: nil, external_ids: nil, after: nil, before: nil, status: nil, ids: nil, limit: nil,
                  user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        tags: tags,
        external_ids: external_ids,
        after: after,
        before: before,
        status: status,
        ids: ids,
        limit: limit,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'CorporateTransaction',
        resource_maker: proc { |json|
          CorporateTransaction.new(
            id: json['id'],
            amount: json['amount'],
            balance: json['balance'],
            description: json['description'],
            source: json['source'],
            tags: json['tags'],
            created: json['created']
          )
        }
      }
    end
  end
end
