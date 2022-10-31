# frozen_string_literal: true

require_relative('../../starkcore/lib/starkcore')
require_relative('../utils/rest')

module StarkBank
  # # TaxPayment object
  #
  # When you initialize a TaxPayment, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (conditionally required):
  # - line [string, default nil]: Number sequence that describes the payment. Either 'line' or 'bar_code' parameters are required. If both are sent, they must match. ex: '85800000003 0 28960328203 1 56072020190 5 22109674804 0'
  # - bar_code [string, default nil]: Bar code number that describes the payment. Either 'line' or 'barCode' parameters are required. If both are sent, they must match. ex: '83660000001084301380074119002551100010601813'
  #
  # ## Parameters (required):
  # - description [string]: Text to be displayed in your statement (min. 10 characters). ex: 'payment ABC'
  #
  # ## Parameters (optional):
  # - scheduled [Date, DateTime, Time or string, default today]: payment scheduled date. ex: Date.new(2020, 3, 10)
  # - tags [list of strings, default nil]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - id [string, default nil]: unique id returned when payment is created. ex: '5656565656565656'
  # - type [string, default nil]: tax type. ex: 'das'
  # - status [string, default nil]: current payment status. ex: 'success' or 'failed'
  # - amount [int, default nil]: amount automatically calculated from line or bar_code. ex: 23456 (= R$ 234.56)
  # - fee [integer, default nil]: fee charged when tax payment is created. ex: 200 (= R$ 2.00)
  # - created [DateTime, default nil]: creation datetime for the Invoice. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime, default nil]: latest update datetime for the Invoice. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class TaxPayment < StarkCore::Utils::Resource
    attr_reader :id, :line, :bar_code, :description, :tags, :scheduled, :status, :amount, :fee, :type, :updated, :created
    def initialize(
      id: nil, line: nil, bar_code: nil, description:, tags: nil, scheduled: nil, 
      status: nil, amount: nil, fee: nil, type: nil, updated: nil, created: nil
    )
      super(id)
      @line = line
      @bar_code = bar_code
      @description = description
      @tags = tags
      @scheduled = StarkCore::Utils::Checks.check_date(scheduled)
      @status = status
      @amount = amount
      @fee = fee
      @type = type
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
      @created = StarkCore::Utils::Checks.check_datetime(created)
    end

    # # Create TaxPayments
    #
    # Send a list of TaxPayment objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - payments [list of TaxPayment objects]: list of TaxPayment objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of TaxPayment objects with updated attributes
    def self.create(payments, user: nil)
      StarkBank::Utils::Rest.post(entities: payments, user: user, **resource)
    end

    # # Retrieve a specific TaxPayment
    #
    # Receive a single TaxPayment object previously created by the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - TaxPayment object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve a specific TaxPayment pdf file
    #
    # Receive a single TaxPayment pdf file generated in the Stark Bank API by passing its id.
    # Only valid for tax payments with 'success' status.
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - TaxPayment pdf file
    def self.pdf(id, user: nil)
      StarkBank::Utils::Rest.get_content(id: id, user: user, sub_resource_name: 'pdf', **resource)
    end

    # # Retrieve TaxPayments
    #
    # Receive a generator of TaxPayment objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date , DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'paid' or 'registered'
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of TaxPayment objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        tags: tags,
        ids: ids,
        status: status,
        user: user,
        **resource
      )
    end

    # # Retrieve paged Tax Payments
    #
    # Receive a list of up to 100 Tax Payment objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date , DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'paid' or 'registered'
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of Tax Payment objects with updated attributes and cursor to retrieve the next page of Tax Payment objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        tags: tags,
        ids: ids,
        status: status,
        user: user,
        **resource
      )
    end

    # # Delete a TaxPayment entity
    #
    # Delete a TaxPayment entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: UtilityPayment unique id. ex:'5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - deleted TaxPayment object
    def self.delete(id, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'TaxPayment',
        resource_maker: proc { |json|
          TaxPayment.new(
            id: json['id'],
            line: json['line'],
            bar_code: json['bar_code'],
            description: json['description'],
            tags: json['tags'],
            scheduled: json['scheduled'],
            status: json['status'],
            amount: json['amount'],
            fee: json['fee'],
            type: json['type'],
            updated: json['updated'],
            created: json['created']
          )
        }
      }
    end
  end
end
