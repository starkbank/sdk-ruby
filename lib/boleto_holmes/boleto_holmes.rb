# frozen_string_literal: true

require_relative('../../starkcore/lib/starkcore')
require_relative('../utils/rest')

module StarkBank
  # # BoletoHolmes object
  #
  # When you initialize a BoletoHolmes, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - boleto_id [string]: investigated boleto entity ID. ex: '5656565656565656'
  #
  # ## Parameters (optional):
  # - tags [list of strings]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - id [string, default nil]: unique id returned when holmes is created. ex: '5656565656565656'
  # - status [string, default nil]: current holmes status. ex: 'solving' or 'solved'
  # - result [string, default nil]: result of boleto status investigation. ex: 'paid' or 'cancelled'
  # - created [DateTime, default nil]: creation datetime for the Boleto. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime, default nil]: latest update datetime for the holmes. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class BoletoHolmes < StarkCore::Utils::Resource
    attr_reader :boleto_id, :tags, :id, :status, :result, :created, :updated
    def initialize(
      boleto_id:, tags: nil, id: nil, status: nil, result: nil, created: nil, updated: nil
    )
      super(id)
      @boleto_id = boleto_id
      @tags = tags
      @status = status
      @result = result
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create BoletoHolmes
    #
    # Send a list of BoletoHolmes objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - holmes [list of BoletoHolmes objects]: list of BoletoHolmes objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of BoletoHolmes objects with updated attributes
    def self.create(holmes, user: nil)
      StarkBank::Utils::Rest.post(entities: holmes, user: user, **resource)
    end

    # # Retrieve a specific BoletoHolmes
    #
    # Receive a single BoletoHolmes object previously created by the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - BoletoHolmes object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve BoletoHolmes
    #
    # Receive a generator of BoletoHolmes objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'solved'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - boleto_id [string, default nil]: filter for holmes that investigate a specific boleto by its ID. ex: '5656565656565656'
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of BoletoHolmes objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, boleto_id: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        boleto_id: boleto_id,
        user: user,
        **resource
      )
    end

    # # Retrieve paged BoletoHolmes
    #
    # Receive a list of up to 100 BoletoHolmes objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'solved'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - boleto_id [string, default nil]: filter for holmes that investigate a specific boleto by its ID. ex: '5656565656565656'
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of BoletoHolmes objects with updated attributes and cursor to retrieve the next page of BoletoHolmes objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, boleto_id: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        boleto_id: boleto_id,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'BoletoHolmes',
        resource_maker: proc { |json|
          BoletoHolmes.new(
            boleto_id: json['boleto_id'],
            tags: json['tags'],
            id: json['id'],
            status: json['status'],
            result: json['result'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
