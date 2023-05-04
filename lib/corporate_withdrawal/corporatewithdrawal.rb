# frozen_string_literal: true

require 'starkcore'
require_relative('../utils/rest')

module StarkBank
  # # CorporateWithdrawal object
  #
  # The CorporateWithdrawal objects created in your Workspace return cash from your Corporate balance to your Banking balance.
  #
  # ## Parameters (required):
  # - amount [integer]: CorporateWithdrawal value in cents. Minimum = 0 (any value will be accepted). ex: 1234 (= R$ 12.34)
  # - external_id [string] CorporateWithdrawal external ID. ex: '12345'
  #
  # ## Parameters (optional):
  # - tags [list of strings, default nil]: list of strings for tagging. ex: ['tony', 'stark']
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when CorporateWithdrawal is created. ex: '5656565656565656'
  # - transaction_id [string]: Stark Bank ledger transaction ids linked to this CorporateWithdrawal
  # - corporate_transaction_id [string]: corporate ledger transaction ids linked to this CorporateWithdrawal
  # - updated [DateTime]: latest update datetime for the CorporateWithdrawal. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - created [DateTime]: creation datetime for the CorporateWithdrawal. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class CorporateWithdrawal < StarkCore::Utils::Resource
    attr_reader :amount, :external_id, :tags, :id, :transaction_id, :corporate_transaction_id, :updated, :created
    def initialize(
      amount:, external_id:, tags: nil, id: nil, transaction_id: nil, corporate_transaction_id: nil,
      updated: nil, created: nil
    )
      super(id)
      @amount = amount
      @external_id = external_id
      @tags = tags
      @transaction_id = transaction_id
      @corporate_transaction_id = corporate_transaction_id
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
      @created = StarkCore::Utils::Checks.check_datetime(created)
    end

    # # Create a CorporateWithdrawal
    #
    # Send a single CorporateWithdrawal object for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - withdrawal [CorporateWithdrawal object]: CorporateWithdrawal object to be created in the API.
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - CorporateWithdrawal object with updated attributes
    def self.create(withdrawal, user: nil)
      StarkBank::Utils::Rest.post_single(entity: withdrawal, user: user, **resource)
    end

    # # Retrieve a specific CorporateWithdrawal
    #
    # Receive a single CorporateWithdrawal object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - CorporateWithdrawal object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve CorporateWithdrawals
    #
    # Receive a generator of CorporateWithdrawal objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - external_ids [list of strings, default nil]: external IDs. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of CorporateWithdrawal objects with updated attributes
    def self.query(limit: nil, external_ids: nil, after: nil, before: nil, tags: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        external_ids: external_ids,
        after: after,
        before: before,
        tags: tags,
        user: user,
        **resource
      )
    end

    # # Retrieve paged CorporateWithdrawals
    #
    # Receive a list of up to 100 CorporateWithdrawal objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call.
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - external_ids [list of strings, default nil]: external IDs. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of CorporateWithdrawal objects with updated attributes
    # - cursor to retrieve the next page of CorporateWithdrawal objects
    def self.page(cursor: nil, limit: nil, external_ids: nil, after: nil, before: nil, tags: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        external_ids: external_ids,
        after: after,
        before: before,
        tags: tags,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'CorporateWithdrawal',
        resource_maker: proc { |json|
          CorporateWithdrawal.new(
            id: json['id'],
            amount: json['amount'],
            external_id: json['external_id'],
            tags: json['tags'],
            transaction_id: json['transaction_id'],
            corporate_transaction_id: json['corporate_transaction_id'],
            updated: json['updated'],
            created: json['created']
          )
        }
      }
    end
  end
end
