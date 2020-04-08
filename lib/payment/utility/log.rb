# frozen_string_literal: true

require_relative('../../utils/resource')
require_relative('../../utils/rest')
require_relative('../../utils/checks')
require_relative('utility')

module StarkBank
  class UtilityPayment
    # # UtilityPayment::Log object
    #
    # Every time a UtilityPayment entity is modified, a corresponding UtilityPayment::Log
    # is generated for the entity. This log is never generated by the user, but it can
    # be retrieved to check additional information on the UtilityPayment.
    #
    # ## Attributes:
    # - id [string]: unique id returned when the log is created. ex: "5656565656565656"
    # - payment [UtilityPayment]: UtilityPayment entity to which the log refers to.
    # - errors [list of strings]: list of errors linked to this BoletoPayment event.
    # - type [string]: type of the UtilityPayment event which triggered the log creation. ex: "registered" or "paid"
    # - created [DateTime]: creation datetime for the payment. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
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
      # - id [string]: object unique id. ex: "5656565656565656"
      #
      # ## Parameters (optional):
      # - user [Project object]: Project object. Not necessary if StarkBank.user was set before function call
      #
      # ## Return:
      # - Log object with updated attributes
      def self.get(id:, user: nil)
        StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
      end

      # # Retrieve Logs
      #
      # Receive a generator of Log objects previously created in the Stark Bank API
      #
      # ## Parameters (optional):
      # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
      # - payment_ids [list of strings, default nil]: list of UtilityPayment ids to filter retrieved objects. ex: ["5656565656565656", "4545454545454545"]
      # - types [list of strings, default nil]: filter retrieved objects by event types. ex: "paid" or "registered"
      # - user [Project object, default nil]: Project object. Not necessary if StarkBank.user was set before function call
      #
      # ## Return:
      # - list of Log objects with updated attributes
      def self.query(limit: nil, payment_ids: nil, types: nil, user: nil)
        StarkBank::Utils::Rest.get_list(user: user, limit: limit, payment_ids: payment_ids, types: types, **resource)
      end

      def self.resource
        payment_maker = StarkBank::UtilityPayment.resource[:resource_maker]
        {
          resource_name: 'UtilityPaymentLog',
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
