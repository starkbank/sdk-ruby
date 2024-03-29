# frozen_string_literal: true

require('json')
require('starkcore')
require_relative('../utils/rest')
require_relative('../utils/parse')
require_relative('../error')
require_relative('../boleto/log')
require_relative('../boleto_holmes/log')
require_relative('../invoice/log')
require_relative('../deposit/log')
require_relative('../brcode_payment/log')
require_relative('../transfer/log')
require_relative('../boleto_payment/log')
require_relative('../utility_payment/log')
require_relative('../tax_payment/log')
require_relative('../darf_payment/log')

module StarkBank
  # # Webhook Event object
  #
  # An Event is the notification received from the subscription to the Webhook.
  # Events cannot be created, but may be retrieved from the Stark Bank API to
  # list all generated updates on entities.
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when the event is created. ex: '5656565656565656'
  # - log [Log]: a Log object from one the subscription services (TransferLog, InvoiceLog, BoletoLog, BoletoPaymentlog or UtilityPaymentLog)
  # - created [DateTime]: creation datetime for the notification event. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - is_delivered [bool]: true if the event has been successfully delivered to the user url. ex: False
  # - workspace_id [string]: ID of the Workspace that generated this event. Mostly used when multiple Workspaces have Webhooks registered to the same endpoint. ex: '4545454545454545'
  # - subscription [string]: service that triggered this event. ex: 'transfer', 'utility-payment'
  class Event < StarkCore::Utils::Resource
    attr_reader :id, :log, :created, :is_delivered, :workspace_id, :subscription
    def initialize(id:, log:, created:, is_delivered:, workspace_id:, subscription:)
      super(id)
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @is_delivered = is_delivered
      @workspace_id = workspace_id
      @subscription = subscription

      resource = {
        'transfer': StarkBank::Transfer::Log.resource,
        'invoice': StarkBank::Invoice::Log.resource,
        'deposit': StarkBank::Deposit::Log.resource,
        'brcode-payment': StarkBank::BrcodePayment::Log.resource,
        'boleto': StarkBank::Boleto::Log.resource,
        'boleto-payment': StarkBank::BoletoPayment::Log.resource,
        'utility-payment': StarkBank::UtilityPayment::Log.resource,
        'tax-payment': StarkBank::TaxPayment::Log.resource,
        'darf-payment': StarkBank::DarfPayment::Log.resource,
        'boleto-holmes': StarkBank::BoletoHolmes::Log.resource
      }[subscription.to_sym]

      @log = log
      @log = StarkCore::Utils::API.from_api_json(resource[:resource_maker], log) unless resource.nil?
    end

    # # Retrieve a specific notification Event
    #
    # Receive a single notification Event object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Event object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve notification Events
    #
    # Receive a generator of notification Event objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - is_delivered [bool, default nil]: bool to filter successfully delivered events. ex: True or False
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of Event objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, is_delivered: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        user: user,
        limit: limit,
        after: after,
        before: before,
        is_delivered: is_delivered,
        **resource
      )
    end

    # # Retrieve paged Events
    #
    # Receive a list of up to 100 Event objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - is_delivered [bool, default nil]: bool to filter successfully delivered events. ex: True or False
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of Event objects with updated attributes and cursor to retrieve the next page of Event objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, is_delivered: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        is_delivered: is_delivered,
        user: user,
        **resource
      )
    end

    # # Delete a notification Event
    #
    # Delete a of notification Event entity previously created in the Stark Bank API by its ID
    #
    # ## Parameters (required):
    # - id [string]: Event unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - deleted Event object
    def self.delete(id, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    # # Update notification Event entity
    #
    # Update notification Event by passing id.
    # If is_delivered is True, the event will no longer be returned on queries with is_delivered=False.
    #
    # ## Parameters (required):
    # - id [list of strings]: Event unique ids. ex: '5656565656565656'
    # - is_delivered [bool]: If True and event hasn't been delivered already, event will be set as delivered. ex: True
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - target Event with updated attributes
    def self.update(id, is_delivered:, user: nil)
      StarkBank::Utils::Rest.patch_id(id: id, user: user, is_delivered: is_delivered, **resource)
    end

    # # Create single notification Event from a content string
    #
    # Create a single Event object received from event listening at subscribed user endpoint.
    # If the provided digital signature does not check out with the StarkBank public key, a
    # starkbank.exception.InvalidSignatureException will be raised.
    #
    # ## Parameters (required):
    # - content [string]: response content from request received at user endpoint (not parsed)
    # - signature [string]: base-64 digital signature received at response header 'Digital-Signature'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Parsed Event object
    def self.parse(content:, signature:, user: nil)
      StarkBank::Utils::Parse.parse_and_verify(
        content: content,
        signature: signature,
        user: user,
        resource: resource,
        key: 'event'
      )
    end

    def self.resource
      {
        resource_name: 'Event',
        resource_maker: proc { |json|
          Event.new(
            id: json['id'],
            log: json['log'],
            created: json['created'],
            is_delivered: json['is_delivered'],
            workspace_id: json['workspace_id'],
            subscription: json['subscription']
          )
        }
      }
    end
  end
end
