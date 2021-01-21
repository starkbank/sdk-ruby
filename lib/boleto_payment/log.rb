# frozen_string_literal: true

require_relative('../utils/resource')
require_relative('../utils/rest')
require_relative('../utils/checks')
require_relative('boleto_payment')

module StarkBank
  class BoletoPayment
    # # BoletoPayment::Log object
    #
    # Every time a BoletoPayment entity is modified, a corresponding BoletoPayment::Log
    # is generated for the entity. This log is never generated by the
    # user, but it can be retrieved to check additional information
    # on the BoletoPayment.
    #
    # ## Attributes:
    # - id [string]: unique id returned when the log is created. ex: '5656565656565656'
    # - payment [BoletoPayment]: BoletoPayment entity to which the log refers to.
    # - errors [list of strings]: list of errors linked to this BoletoPayment event.
    # - type [string]: type of the BoletoPayment event which triggered the log creation. ex: 'processing' or 'success'
    # - created [DateTime]: creation datetime for the log. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
    class Log < StarkBank::Utils::Resource
      attr_reader :id, :created, :type, :errors, :payment
      def initialize(id:, created:, type:, errors:, payment:)
        super(id)
        @type = type
        @errors = errors
        @payment = payment
        @created = StarkBank::Utils::Checks.check_datetime(created)
      end

      # # Retrieve a specific Log
      #
      # Receive a single Log object previously created by the Stark Bank API by passing its id
      #
      # ## Parameters (required):
      # - id [string]: object unique id. ex: '5656565656565656'
      #
      # ## Parameters (optional):
      # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
      #
      # ## Return:
      # - Log object with updated attributes
      def self.get(id, user: nil)
        StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
      end

      # # Retrieve Logs
      #
      # Receive a generator of Log objects previously created in the Stark Bank API
      #
      # ## Parameters (optional):
      # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
      # - after [Date, DateTime, Time or string, default nil] date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
      # - before [Date, DateTime, Time or string, default nil] date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
      # - types [list of strings, default nil]: filter retrieved objects by event types. ex: 'success' or 'failed'
      # - payment_ids [list of strings, default nil]: list of BoletoPayment ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
      # - user [Organization/Project object]: Organization or Project object. Not necessary if Starkbank.user was set before function call
      #
      # ## Return:
      # - list of Log objects with updated attributes
      def self.query(limit: nil, after: nil, before: nil, types: nil, payment_ids: nil, user: nil)
        after = StarkBank::Utils::Checks.check_date(after)
        before = StarkBank::Utils::Checks.check_date(before)
        StarkBank::Utils::Rest.get_list(
          limit: limit,
          after: after,
          before: before,
          types: types,
          payment_ids: payment_ids,
          user: user,
          **resource
        )
      end

      def self.resource
        payment_maker = StarkBank::BoletoPayment.resource[:resource_maker]
        {
          resource_name: 'BoletoPaymentLog',
          resource_maker: proc { |json|
            Log.new(
              id: json['id'],
              created: json['created'],
              type: json['type'],
              errors: json['errors'],
              payment: StarkBank::Utils::API.from_api_json(payment_maker, json['payment'])
            )
          }
        }
      end
    end
  end
end
