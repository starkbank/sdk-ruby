# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # InvoicePullRequest object
  #
  # When you initialize an InvoicePullRequest, the entity will not be automatically sent to the Stark Bank API.
  # The 'create' function sends the objects to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - subscription_id [string]: unique id of the InvoicePullSubscription related to the request. ex: '5656565656565656'
  # - invoice_id [string]: id of the invoice previously created to be sent for payment. ex: '5656565656565656'
  # - due [DateTime or string]: payment scheduled date in UTC ISO format. ex: '2023-10-28T17:59:26.249976+00:00'
  #
  # ## Parameters (optional):
  # - attempt_type [string, default 'default']: attempt type for the payment. Options: 'default', 'retry'. ex: 'retry'
  # - tags [list of strings, default []]: list of strings for tagging. ex: ['travel', 'food']
  # - external_id [string, default nil]: a string that must be unique among all your InvoicePullRequests. Duplicated external_ids will cause failures. ex: 'my-external-id'
  # - display_description [string, default nil]: description to be shown to the payer. ex: 'Payment for services'
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when InvoicePullRequest is created. ex: '5656565656565656'
  # - status [string]: current InvoicePullRequest status. ex: 'pending', 'scheduled', 'success', 'failed', 'canceled'
  # - installment_id [string]: unique id of the installment related to this request. ex: '5656565656565656'
  # - created [DateTime]: creation datetime for the InvoicePullRequest. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: latest update datetime for the InvoicePullRequest. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class InvoicePullRequest < StarkCore::Utils::Resource
    attr_reader :subscription_id, :invoice_id, :due, :attempt_type, :tags, :external_id, :display_description,
                :id, :status, :installment_id, :created, :updated
    def initialize(
      subscription_id:, invoice_id:, due:, attempt_type: nil, tags: nil, external_id: nil, display_description: nil,
      id: nil, status: nil, installment_id: nil, created: nil, updated: nil
    )
      super(id)
      @subscription_id = subscription_id
      @invoice_id = invoice_id
      @due = StarkCore::Utils::Checks.check_datetime(due)
      @attempt_type = attempt_type
      @tags = tags
      @external_id = external_id
      @display_description = display_description
      @status = status
      @installment_id = installment_id
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create InvoicePullRequests
    #
    # Send a list of InvoicePullRequest objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - requests [list of InvoicePullRequest objects]: list of InvoicePullRequest objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of InvoicePullRequest objects with updated attributes
    def self.create(requests, user: nil)
      StarkBank::Utils::Rest.post(entities: requests, user: user, **resource)
    end

    # # Retrieve a specific InvoicePullRequest
    #
    # Receive a single InvoicePullRequest object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - InvoicePullRequest object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve InvoicePullRequests
    #
    # Receive a generator of InvoicePullRequest objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created or updated only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created or updated only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['travel', 'food']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - invoice_ids [list of strings, default nil]: list of strings to get specific entities by invoice ids. ex: ['12376517623', '1928367198236']
    # - subscription_ids [list of strings, default nil]: list of strings to get specific entities by subscription ids. ex: ['12376517623', '1928367198236']
    # - external_ids [list of strings, default nil]: list of strings to get specific entities by external ids. ex: ['my-external-id-1', 'my-external-id-2']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'success' or 'failed'
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of InvoicePullRequest objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, tags: nil, ids: nil, invoice_ids: nil, subscription_ids: nil, external_ids: nil, status: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        tags: tags,
        ids: ids,
        invoice_ids: invoice_ids,
        subscription_ids: subscription_ids,
        external_ids: external_ids,
        status: status,
        user: user,
        **resource
      )
    end

    # # Retrieve paged InvoicePullRequests
    #
    # Receive a list of up to 100 InvoicePullRequest objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created or updated only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created or updated only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['travel', 'food']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - invoice_ids [list of strings, default nil]: list of strings to get specific entities by invoice ids. ex: ['12376517623', '1928367198236']
    # - subscription_ids [list of strings, default nil]: list of strings to get specific entities by subscription ids. ex: ['12376517623', '1928367198236']
    # - external_ids [list of strings, default nil]: list of strings to get specific entities by external ids. ex: ['my-external-id-1', 'my-external-id-2']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'success' or 'failed'
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of InvoicePullRequest objects with updated attributes and cursor to retrieve the next page of InvoicePullRequest objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, tags: nil, ids: nil, invoice_ids: nil, subscription_ids: nil, external_ids: nil, status: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        tags: tags,
        ids: ids,
        invoice_ids: invoice_ids,
        subscription_ids: subscription_ids,
        external_ids: external_ids,
        status: status,
        user: user,
        **resource
      )
    end

    # # Cancel an InvoicePullRequest entity
    #
    # Cancel an InvoicePullRequest entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: InvoicePullRequest unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - canceled InvoicePullRequest object
    def self.cancel(id, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'InvoicePullRequest',
        resource_maker: proc { |json|
          InvoicePullRequest.new(
            id: json['id'],
            subscription_id: json['subscription_id'],
            invoice_id: json['invoice_id'],
            due: json['due'],
            attempt_type: json['attempt_type'],
            tags: json['tags'],
            external_id: json['external_id'],
            display_description: json['display_description'],
            status: json['status'],
            installment_id: json['installment_id'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
