# frozen_string_literal: true

require_relative('../../utils/resource')
require_relative('../../utils/rest')
require_relative('../../utils/checks')

module StarkBank
  # # UtilityPayment object
  #
  # When you initialize a UtilityPayment, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (conditionally required):
  # - line [string, default None]: Number sequence that describes the payment. Either 'line' or 'bar_code' parameters are required. If both are sent, they must match. ex: "34191.09008 63571.277308 71444.640008 5 81960000000062"
  # - bar_code [string, default None]: Bar code number that describes the payment. Either 'line' or 'barCode' parameters are required. If both are sent, they must match. ex: "34195819600000000621090063571277307144464000"
  #
  # ## Parameters (required):
  # - description [string]: Text to be displayed in your statement (min. 10 characters). ex: "payment ABC"
  #
  # ## Parameters (optional):
  # - scheduled [datetime.date, default today]: payment scheduled date. ex: datetime.date(2020, 3, 10)
  # - tags [list of strings]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - id [string, default None]: unique id returned when payment is created. ex: "5656565656565656"
  # - status [string, default None]: current payment status. ex: "registered" or "paid"
  # - amount [int, default None]: amount automatically calculated from line or bar_code. ex: 23456 (= R$ 234.56)
  # - fee [integer, default None]: fee charged when utility payment is created. ex: 200 (= R$ 2.00)
  # - created [datetime.datetime, default None]: creation datetime for the payment. ex: datetime.datetime(2020, 3, 10, 10, 30, 0, 0)
  class UtilityPayment < StarkBank::Utils::Resource
    attr_reader :description, :line, :bar_code, :tags, :scheduled, :id, :amount, :fee, :status, :created
    def initialize(description:, line: nil, bar_code: nil, tags: nil, scheduled: nil, id: nil, amount: nil, fee: nil, status: nil, created: nil)
      super(id)
      @description = description
      @line = line
      @bar_code = bar_code
      @tags = tags
      @scheduled = StarkBank::Utils::Checks.check_datetime(scheduled)
      @amount = amount
      @fee = fee
      @status = status
      @created = StarkBank::Utils::Checks.check_datetime(created)
    end

    # # Create UtilityPayments
    #
    # Send a list of UtilityPayment objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - payments [list of UtilityPayment objects]: list of UtilityPayment objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of UtilityPayment objects with updated attributes
    def self.create(payments:, user: nil)
      StarkBank::Utils::Rest.post(entities: payments, user: user, **resource)
    end

    # # Retrieve a specific UtilityPayment
    #
    # Receive a single UtilityPayment object previously created by the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: "5656565656565656"
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if starkbank.user was set before function call
    def self.get(id:, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve a specific UtilityPayment pdf file
    #
    # Receive a single UtilityPayment pdf file generated in the Stark Bank API by passing its id.
    # Only valid for utility payments with "success" status.
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: "5656565656565656"
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - UtilityPayment pdf file
    def self.pdf(id:, user: nil)
      StarkBank::Utils::Rest.get_pdf(id: id, user: user, **resource)
    end

    # # Retrieve UtilityPayments
    #
    # Receive a generator of UtilityPayment objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default None]: maximum number of objects to be retrieved. Unlimited if None. ex: 35
    # - status [string, default None]: filter for status of retrieved objects. ex: "paid"
    # - tags [list of strings, default None]: tags to filter retrieved objects. ex: ["tony", "stark"]
    # - ids [list of strings, default None]: list of ids to filter retrieved objects. ex: ["5656565656565656", "4545454545454545"]
    # - after [datetime.date, default None] date filter for objects created only after specified date. ex: datetime.date(2020, 3, 10)
    # - before [datetime.date, default None] date filter for objects only before specified date. ex: datetime.date(2020, 3, 10)
    # - user [Project object, default None]: Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of UtilityPayment objects with updated attributes
    def self.query(limit: nil, status: nil, tags: nil, ids: nil, after: nil, before: nil, user: nil)
      after = StarkBank::Utils::Checks.check_date(after)
      before = StarkBank::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_list(user: user, limit: limit, status: status, tags: tags, ids: ids, after: after, before: before, **resource)
    end

    # # Delete a UtilityPayment entity
    #
    # Delete a UtilityPayment entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: UtilityPayment unique id. ex: "5656565656565656"
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - deleted UtilityPayment with updated attributes
    def self.delete(id:, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'UtilityPayment',
        resource_maker: proc { |json|
          UtilityPayment.new(
            id: json['id'],
            description: json['description'],
            line: json['line'],
            bar_code: json['bar_code'],
            tags: json['tags'],
            scheduled: json['scheduled'],
            amount: json['amount'],
            fee: json['fee'],
            status: json['status'],
            created: json['created']
          )
        }
      }
    end
  end
end
