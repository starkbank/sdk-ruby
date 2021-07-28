# frozen_string_literal: true

require_relative('../utils/resource')
require_relative('../utils/rest')
require_relative('../utils/checks')
require_relative('event')

module StarkBank
  class Event
    # # Event::Attempt object
    #
    # When an Event delivery fails, an event attempt will be registered.
    # It carries information meant to help you debug event reception issues.
    #
    # ## Attributes:
    # - id [string]: unique id that identifies the delivery attempt. ex: "5656565656565656"
    # - code [string]: delivery error code. ex: badHttpStatus, badConnection, timeout
    # - message [string]: delivery error full description. ex: "HTTP POST request returned status 404"
    # - event_id [string]: ID of the Event whose delivery failed. ex: "4848484848484848"
    # - webhook_id [string]: ID of the Webhook that triggered this event. ex: "5656565656565656"
    # - created [DateTime]: creation datetime for the log. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
    class Attempt < StarkBank::Utils::Resource
      attr_reader :id, :code, :message, :event_id, :webhook_id, :created
      def initialize(id:, code:, message:, event_id:, webhook_id:, created:)
        super(id)
        @code = code
        @message = message
        @event_id = event_id
        @webhook_id = webhook_id
        @created = StarkBank::Utils::Checks.check_datetime(created)
      end

      # # Retrieve a specific Event::Attempt
      #
      # Receive a single Event::Attempt object previously created by the Stark Bank API by its id
      #
      # ## Parameters (required):
      # - id [string]: object unique id. ex: '5656565656565656'
      #
      # ## Parameters (optional):
      # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
      #
      # ## Return:
      # - Event::Attempt object with updated attributes
      def self.get(id, user: nil)
        StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
      end

      # # Retrieve Event::Attempts
      #
      # Receive a generator of Event::Attempt objects previously created in the Stark Bank API
      #
      # ## Parameters (optional):
      # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
      # - after [Date, DateTime, Time or string, default nil] date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
      # - before [Date, DateTime, Time or string, default nil] date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
      # - event_ids [list of strings, default None]: list of Event ids to filter attempts. ex: ["5656565656565656", "4545454545454545"]
      # - webhook_ids [list of strings, default None]: list of Webhook ids to filter attempts. ex: ["5656565656565656", "4545454545454545"]
      # - user [Organization/Project object]: Organization or Project object. Not necessary if Starkbank.user was set before function call
      #
      # ## Return:
      # - generator of Event::Attempt objects with updated attributes
      def self.query(limit: nil, after: nil, before: nil, event_ids: nil, webhook_ids: nil, user: nil)
        after = StarkBank::Utils::Checks.check_date(after)
        before = StarkBank::Utils::Checks.check_date(before)
        StarkBank::Utils::Rest.get_list(
          limit: limit,
          after: after,
          before: before,
          event_ids: event_ids,
          webhook_ids: webhook_ids,
          user: user,
          **resource
        )
      end

      def self.resource
        {
          resource_name: 'EventAttempt',
          resource_maker: proc { |json|
            Attempt.new(
              id: json['id'],
              code: json['code'],
              message: json['message'],
              event_id: json['event_id'],
              webhook_id: json['webhook_id'],
              created: json['created']
            )
          }
        }
      end
    end
  end
end
