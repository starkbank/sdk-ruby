# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # SplitProfile object
  #
  # When you create a Split, the entity SplitProfile will be automatically created, if you haven't
  # created a Split yet, you can use the 'put' method to create your SplitProfile.
  #
  # ## Parameters (required):
  # - interval [string]: frequency of transfer. Options: 'day', 'week', 'month'
  # - delay [DateInterval or integer]: how long the amount will stay at the workspace in milliseconds, ex: 604800
  #
  # ## Parameters (optional):
  # - tags [list of strings, default nil]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when the splitProfile is created. ex: '5656565656565656'
  # - status [string]: current splitProfile status. ex: 'created'
  # - created [DateTime]: creation datetime for the splitProfile. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: latest update datetime for the splitProfile. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class SplitProfile < StarkCore::Utils::Resource
    attr_reader :interval, :delay, :tags, :id, :status, :created, :updated
    def initialize(delay:, interval:, tags: nil, id: nil, status: nil, created: nil, updated: nil)
      super(id)
      @interval = interval
      @delay = delay
      @tags = tags
      @status = status
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create SplitProfile or update it if you already have it created
    #
    # Send a list of SplitProfile objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - profiles [list of SplitProfile objects]: list of SplitProfile objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of SplitProfile objects with updated attributes
    def self.put(profiles, user: nil)
      StarkBank::Utils::Rest.put_multi(entities: profiles, user: user, **resource)
    end

    # # Retrieve a specific SplitProfile
    #
    # Receive a single SplitProfile object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - SplitProfile object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve SplitProfiles
    #
    # Receive a generator of SplitProfile objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created or updated only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created or updated only before specified date. ex: Date.new(2020, 3, 10)
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of SplitProfile objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        user: user,
        **resource
      )
    end

    # # Retrieve paged SplitProfiles
    #
    # Receive a list of up to 100 SplitProfile objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 50
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - receiver_ids [list of strings, default nil]: list of SplitReceiver ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'success'
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of SplitProfile objects with updated attributes
    # - cursor to retrieve the next page of SplitProfile objects
    def self.page(
      cursor: nil, limit: nil, after: nil, before: nil, tags: nil, ids: nil, receiver_ids: nil, status: nil,
      user: nil
    )
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        tags: tags,
        ids: ids,
        receiver_ids: receiver_ids,
        status: status,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'SplitProfile',
        resource_maker: proc { |json|
          SplitProfile.new(
            id: json['id'],
            interval: json['interval'],
            delay: json['delay'],
            tags: json['tags'],
            status: json['status'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
