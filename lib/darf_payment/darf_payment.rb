# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')


module StarkBank
  # # DarfPayment object
  #
  # When you initialize a DarfPayment, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - description [string]: Text to be displayed in your statement (min. 10 characters). ex: 'payment ABC'
  # - revenue_code [string]: 4-digit tax code assigned by Federal Revenue. ex: '5948'
  # - tax_id [tax_id]: tax id (formatted or unformatted) of the payer. ex: '12.345.678/0001-95'
  # - competence [Date, DateTime, Time or string, default today]: competence month of the service. ex: Date.new(2020, 3, 10)
  # - nominal_amount [int]: amount due in cents without fee or interest. ex: 23456 (= R$ 234.56)
  # - fine_amount [int]: fixed amount due in cents for fines. ex: 234 (= R$ 2.34)
  # - interest_amount [int]: amount due in cents for interest. ex: 456 (= R$ 4.56)
  # - due [Date, DateTime, Time or string, default today]: due date for payment. ex: Date.new(2020, 3, 10)
  #
  # ## Parameters (optional):
  # - reference_number [string, default nil]: number assigned to the region of the tax. ex: '08.1.17.00-4'
  # - scheduled [Date, DateTime, Time or string, default today]: payment scheduled date. ex: Date.new(2020, 3, 10)
  # - tags [list of strings, default nil]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when payment is created. ex: '5656565656565656'
  # - status [string]: current payment status. ex: 'success' or 'failed'
  # - amount [int]: Total amount due calculated from other amounts. ex: 24146 (= R$ 241.46)
  # - fee [integer]: fee charged when the DarfPayment is processed. ex: 0 (= R$ 0.00)
  # - transaction_ids [list of strings]: ledger transaction ids linked to this DarfPayment. ex: ["19827356981273"]
  # - created [DateTime]: creation datetime for the Invoice. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: latest update datetime for the Invoice. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class DarfPayment < StarkCore::Utils::Resource
    attr_reader :id, :revenue_code, :tax_id, :competence, :reference_number, :fine_amount, :interest_amount, 
    :due, :description, :tags, :scheduled, :status, :amount, :nominal_amount, :fee, :transaction_ids, :updated, :created
    def initialize(
        id: nil, revenue_code:, tax_id:, competence:, reference_number:, fine_amount:, interest_amount:, due:, description: nil, 
        tags: nil, scheduled: nil, status: nil, amount: nil, nominal_amount: nil, fee: nil, transaction_ids: nil, updated: nil, created: nil
    )
      super(id)
      @revenue_code = revenue_code
      @tax_id = tax_id
      @competence = StarkCore::Utils::Checks.check_date(competence)
      @reference_number = reference_number
      @fine_amount = fine_amount
      @interest_amount = interest_amount
      @due = StarkCore::Utils::Checks.check_date(due)
      @description = description
      @tags = tags
      @scheduled = StarkCore::Utils::Checks.check_date(scheduled)
      @status = status
      @amount = amount
      @nominal_amount = nominal_amount
      @fee = fee
      @transaction_ids = @transaction_ids
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
      @created = StarkCore::Utils::Checks.check_datetime(created)
    end

    # # Create DarfPayments
    #
    # Send a list of DarfPayment objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - payments [list of DarfPayment objects]: list of DarfPayment objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of DarfPayment objects with updated attributes
    def self.create(payments, user: nil)
      StarkBank::Utils::Rest.post(entities: payments, user: user, **resource)
    end

    # # Retrieve a specific DarfPayment
    #
    # Receive a single DarfPayment object previously created by the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - DarfPayment object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve a specific DarfPayment pdf file
    #
    # Receive a single DarfPayment pdf file generated in the Stark Bank API by passing its id.
    # Only valid for darf payments with 'success' status.
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - DarfPayment pdf file
    def self.pdf(id, user: nil)
      StarkBank::Utils::Rest.get_content(id: id, user: user, sub_resource_name: 'pdf', **resource)
    end

    # # Retrieve DarfPayments
    #
    # Receive a generator of DarfPayment objects previously created in the Stark Bank API
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
    # - generator of DarfPayment objects with updated attributes
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

    # # Retrieve paged Darf Payments
    #
    # Receive a list of up to 100 Darf Payment objects previously created in the Stark Bank API and the cursor to the next page.
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
    # - list of Darf Payment objects with updated attributes and cursor to retrieve the next page of Darf Payment objects
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

    # # Delete a DarfPayment entity
    #
    # Delete a DarfPayment entity previously created in the Stark Bank API
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
        resource_name: 'DarfPayment',
        resource_maker: proc { |json|
          DarfPayment.new(
            id: json['id'],
            revenue_code: json['revenue_code'],
            tax_id: json['tax_id'],
            competence: json['competence'],
            reference_number: json['reference_number'],
            fine_amount: json['fine_amount'],
            interest_amount: json['interest_amount'],
            due: json['due'],
            description: json['description'],
            tags: json['tags'],
            scheduled: json['scheduled'],
            status: json['status'],
            amount: json['amount'],
            nominal_amount: json['nominal_amount'],
            fee: json['fee'],
            updated: json['updated'],
            transaction_ids: json['transaction_ids'],
            created: json['created'],          
          )
        }
      }
    end
  end
end
