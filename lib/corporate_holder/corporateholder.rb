# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # CorporateHolder object
  #
  # The CorporateHolder describes a card holder that may group several cards.
  #
  # When you initialize a CorporateHolder, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the created object.
  #
  # ## Parameters (required):
  # - name [string]: card holder name. ex: "Tony Stark"
  #
  # ## Parameters (optional):
  # - center_id [string, default nil]: target cost center ID. ex: "5656565656565656"
  # - permissions [list of Permission objects, default nil]: list of Permission object representing access granted to an user for a particular cardholder.
  # - rules [list of CorporateRule objects, default nil]: [EXPANDABLE] list of holder spending rules.
  # - tags [list of strings, default nil]: list of strings for tagging. ex: ['travel', 'food']
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when CorporateHolder is created. ex: '5656565656565656'
  # - status [string]: current CorporateHolder status. ex: 'active', 'blocked', 'canceled'
  # - updated [DateTime]: latest update datetime for the CorporateHolder. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - created [DateTime]: creation datetime for the log. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class CorporateHolder < StarkCore::Utils::Resource
    attr_reader :id, :name, :center_id, :permissions, :rules, :tags, :status, :updated, :created
    def initialize(
      name:, center_id: nil, permissions: nil, rules: nil, tags: nil, id: nil, status: nil, updated: nil, created: nil
    )
      super(id)
      @name = name
      @center_id = center_id
      @permissions = Permission.parse_permissions(permissions)
      @rules = StarkBank::CorporateRule.parse_rules(rules)
      @tags = tags
      @status = status
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create CorporateHolders
    #
    # Send a list of CorporateHolder objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - holders [list of CorporateHolder objects]: list of CorporateHolder objects to be created in the API
    #
    # ## Parameters (optional):
    # - expand [list of strings, default nil]: fields to expand information. Options: ['rules']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of CorporateHolder objects with updated attributes
    def self.create(holders:, expand: nil, user: nil)
      StarkBank::Utils::Rest.post(entities: holders, expand: expand, user: user, **resource)
    end

    # # Retrieve a specific CorporateHolder
    #
    # Receive a single CorporateHolder object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - expand [list of strings, default nil]: fields to expand information. ex: ['rules']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - CorporateHolder object with updated attributes
    def self.get(id, expand: nil, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, expand: expand, user: user, **resource)
    end

    # # Retrieve CorporateHolders
    #
    # Receive a generator of CorporateHolder objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [list of strings, default nil]: filter for status of retrieved objects. ex: ['active', 'blocked', 'canceled']
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - expand [string, default nil]: fields to expand information. ex: ['rules']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of CorporateHolders objects with updated attributes
    def self.query(limit: nil, ids: nil, after: nil, before: nil, status: nil, tags: nil, expand: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        ids: ids,
        after: after,
        before: before,
        status: status,
        tags: tags,
        expand: expand,
        user: user,
        **resource
      )
    end

    # # Retrieve paged CorporateHolders
    #
    # Receive a list of up to 100 CorporateHolders objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your logs.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call.
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [list of strings, default nil]: filter for status of retrieved objects. ex: ['active', 'blocked', 'canceled']
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - expand [string, default nil]: fields to expand information. ex: ['rules']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of CorporateHolders objects with updated attributes
    # - cursor to retrieve the next page of CorporateHolders objects
    def self.page(cursor: nil, limit: nil, ids: nil, after: nil, before: nil, status: nil, tags: nil, expand: nil,
                  user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        ids: ids,
        after: after,
        before: before,
        status: status,
        tags: tags,
        expand: expand,
        user: user,
        **resource
      )
    end

    # # Update CorporateHolder entity
    #
    # Update a CorporateHolder by passing id.
    #
    # ## Parameters (required):
    # - id [string]: CorporateHolder id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - center_id [string, default nil]: target cost center ID. ex: "5656565656565656"
    # - permissions [list of Permission object, default nil]: list of Permission object representing access granted to an user for a particular cardholder.
    # - status [string, default nil]: You may block the CorporateHolder by passing 'blocked' in the status
    # - name [string, default nil]: card holder name.
    # - tags [list of strings, default nil]: list of strings for tagging
    # - rules [list of CorporateRule objects, default nil]: list of objects that represent the holder's spending rules.
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - target CorporateHolder with updated attributes
    def self.update(id, center_id: nil, permissions: nil, status: nil, name: nil, tags: nil, rules: nil, user: nil)
      StarkBank::Utils::Rest.patch_id(
        id: id,
        center_id: center_id,
        permissions: permissions,
        status: status,
        name: name,
        tags: tags,
        rules: rules,
        user: user,
        **resource
      )
    end

    # # Cancel a CorporateHolder entity
    #
    # Cancel a CorporateHolder entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: CorporateHolder unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - canceled CorporateHolder object
    def self.cancel(id, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'CorporateHolder',
        resource_maker: proc { |json|
          CorporateHolder.new(
            id: json['id'],
            name: json['name'],
            center_id: json['center_id'],
            permissions: json['permissions'],
            rules: json['rules'],
            tags: json['tags'],
            status: json['status'],
            updated: json['updated'],
            created: json['created']
          )
        }
      }
    end
  end
end
