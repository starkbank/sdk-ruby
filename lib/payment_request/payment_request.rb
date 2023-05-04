# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')


module StarkBank
  # # PaymentRequest object
  #
  # A PaymentRequest is an indirect request to access a specific cash-out service
  # (such as Transfer, BrcodePayments, etc.) which goes through the cost center
  #  approval flow on our website. To emit a PaymentRequest, you must direct it to
  #  a specific cost center by its ID, which can be retrieved on our website at the
  #  cost center page.
  #
  # ## Parameters (required):
  # - center_id [String]: target cost center ID. ex: '5656565656565656'
  # - payment [Transfer, BrcodePayment, BoletoPayment, UtilityPayment, Transaction or dictionary]: payment entity that should be approved and executed.
  #
  # ## Parameters (conditionally required):
  # - type [String]: payment type, inferred from the payment parameter if it is not a dictionary. ex: 'transfer', 'brcode-payment'
  #
  # ## Parameters (optional):
  # - due [Date, DateTime, Time or string]: Payment target date in ISO format. ex: 2020-12-31
  # - tags [list of strings]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - id [String]: unique id returned when PaymentRequest is created. ex: '5656565656565656'
  # - amount [integer]: PaymentRequest amount. ex: 100000 = R$1.000,00
  # - description [string]: payment request description. ex: "Tony Stark's Suit"
  # - status [string]: current PaymentRequest status.ex: 'pending' or 'approved'
  # - actions [list of dictionaries]: list of actions that are affecting this PaymentRequest. ex: [{'type': 'member', 'id': '56565656565656, 'action': 'requested'}]
  # - updated [DateTime]: latest update datetime for the PaymentRequest. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - created [DateTime]: creation datetime for the PaymentRequest. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  #
  class PaymentRequest < StarkCore::Utils::Resource
    attr_reader :center_id, :payment, :type, :due, :tags, :amount, :description, :status, :actions, :updated, :created
    def initialize(
      payment:, center_id:, id: nil, type: nil, due: nil, tags: nil, amount: nil, status: nil,
      description: nil, actions: nil, updated: nil, created: nil
    )
      super(id)
      @center_id = center_id
      @due = due
      @tags = tags
      @amount = amount
      @status = status
      @actions = actions
      @description = description
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
      @created = StarkCore::Utils::Checks.check_datetime(created)

      @payment, @type = parse_payment(payment: payment, type: type)
    end

    ## Create PaymentRequests
    # Sends a list of PaymentRequests objects for creating in the Stark Bank API
    #
    # ## Parameters
    # - payment_requests [list of PaymentRequest objects]: list of PaymentRequest objects to be created in the API
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return
    # - list of PaymentRequest objects with updated attributes
    #
    def self.create(payment_requests, user: nil)
      StarkBank::Utils::Rest.post(entities: payment_requests, user: user, **resource)
    end

    # # Retrieve PaymentRequests
    #
    # Receive a generator of PaymentRequest objects previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - center_id [string]: target cost center ID. ex: '5656565656565656'
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default '-created']: sort order considered in response. Valid options are '-created' or '-due'.
    # - type [string, default nil]: payment type, inferred from the payment parameter if it is not a dictionary. ex: 'transfer', 'brcode-payment'
    # - sort [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of PaymentRequest objects with updated attributes
    def self.query(center_id:, limit: nil, after: nil, before: nil, status: nil, type: nil, sort: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        center_id: center_id,
        limit: limit,
        after: after,
        before: before,
        status: status,
        type: type,
        sort: sort,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    # # Retrieve paged PaymentRequests
    #
    # Receive a list of up to 100 PaymentRequest objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'paid' or 'registered'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of PaymentRequest objects with updated attributes and cursor to retrieve the next page of PaymentRequest objects
    def self.page(cursor: nil, center_id:, limit: nil, after: nil, before: nil, status: nil, type: nil, sort: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        center_id: center_id,
        limit: limit,
        after: after,
        before: before,
        status: status,
        type: type,
        sort: sort,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    def parse_payment(payment:, type:)
      return [payment, 'transfer'] if payment.is_a?(StarkBank::Transfer)
      return [payment, 'transaction'] if payment.is_a?(StarkBank::Transaction)
      return [payment, 'brcode-payment'] if payment.is_a?(StarkBank::BrcodePayment)
      return [payment, 'boleto-payment'] if payment.is_a?(StarkBank::BoletoPayment)
      return [payment, 'utility-payment'] if payment.is_a?(StarkBank::UtilityPayment)
      return [payment, 'tax-payment'] if payment.is_a?(StarkBank::TaxPayment)
      return [payment, 'darf-payment'] if payment.is_a?(StarkBank::DarfPayment)

      raise(Exception('Payment must either be a Transfer, a Transaction, a BrcodePayment, BoletoPayment, a UtilityPayment, a TaxPayment, a DarfPayment or a hash.')) unless payment.is_a?(Hash)

      resource = {
        'transfer': StarkBank::Transfer.resource,
        'transaction': StarkBank::Transaction.resource,
        'brcode-payment': StarkBank::BrcodePayment.resource,
        'boleto-payment': StarkBank::BoletoPayment.resource,
        'utility-payment': StarkBank::UtilityPayment.resource,
        'tax-payment': StarkBank::TaxPayment.resource,
        'darf-payment': StarkBank::DarfPayment.resource
      }[type.to_sym]

      payment = StarkCore::Utils::API.from_api_json(resource[:resource_maker], payment) unless resource.nil?

      [payment, type]
    end

    def self.resource
      {
        resource_name: 'PaymentRequest',
        resource_maker: proc { |json|
          PaymentRequest.new(
            id: json['id'],
            payment: json['payment'],
            center_id: json['centerId'],
            type: json['type'],
            tags: json['tags'],
            amount: json['amount'],
            status: json['status'],
            description: json['description'],
            actions: json['actions'],
            updated: json['updated'],
            created: json['created']
          )
        }
      }
    end
  end
end
