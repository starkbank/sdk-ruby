# frozen_string_literal: true

require_relative('../utils/resource')
require_relative('../utils/rest')
require_relative('../utils/checks')

module StarkBank
  # # BrcodePayment object
  #
  # When you initialize a BrcodePayment, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - brcode [string]: String loaded directly from the QRCode or copied from the invoice. ex: '00020126580014br.gov.bcb.pix0136a629532e-7693-4846-852d-1bbff817b5a8520400005303986540510.005802BR5908T'Challa6009Sao Paulo62090505123456304B14A'
  # - tax_id [string]: receiver tax ID (CPF or CNPJ) with or without formatting. ex: '01234567890' or '20.018.183/0001-80'
  # - description [string]: Text to be displayed in your statement (min. 10 characters). ex: 'payment ABC'
  #
  # ## Parameters (conditionally required):
  # - amount [int, default nil]: If the BRCode does not provide an amount, this parameter is mandatory, else it is optional. ex: 23456 (= R$ 234.56)
  #
  # ## Parameters (optional):
  # - scheduled [datetime.date, datetime.datetime or string, default now]: payment scheduled date or datetime. ex: datetime.datetime(2020, 3, 10, 15, 17, 3)
  # - tags [list of strings, default nil]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - id [string, default nil]: unique id returned when payment is created. ex: '5656565656565656'
  # - name [string, nil]: receiver name. ex: 'Jon Snow'
  # - status [string, default nil]: current payment status. ex: 'success' or 'failed'
  # - type [string, default nil]: brcode type. ex: 'static' or 'dynamic'
  # - transaction_ids [list of strings, default nil]: ledger transaction ids linked to this payment. ex: ['19827356981273']
  # - fee [integer, default nil]: fee charged when the brcode payment is created. ex: 200 (= R$ 2.00)
  # - updated [datetime.datetime, default nil]: latest update datetime for the payment. ex: datetime.datetime(2020, 3, 10, 10, 30, 0, 0)
  # - created [datetime.datetime, default nil]: creation datetime for the payment. ex: datetime.datetime(2020, 3, 10, 10, 30, 0, 0)
  class BrcodePayment < StarkBank::Utils::Resource
    attr_reader :brcode, :tax_id, :description, :amount, :scheduled, :tags, :id, :name, :status, :type, :transaction_ids, :fee, :updated, :created
    def initialize(brcode:, tax_id:, description:, amount: nil, scheduled: nil, tags: nil, id: nil, name: nil, status: nil, type: nil, transaction_ids: nil, fee: nil, updated: nil, created: nil)
      super(id)
      @brcode = brcode
      @tax_id = tax_id
      @description = description
      @amount = amount
      @scheduled = StarkBank::Utils::Checks.check_date_or_datetime(scheduled)
      @tags = tags
      @name = name
      @status = status
      @type = type
      @transaction_ids = transaction_ids
      @fee = fee
      @updated = StarkBank::Utils::Checks.check_datetime(updated)
      @created = StarkBank::Utils::Checks.check_datetime(created)
    end

    # # Create BrcodePayments
    #
    # Send a list of BrcodePayment objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - payments [list of BrcodePayment objects]: list of BrcodePayment objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of BrcodePayment objects with updated attributes
    def self.create(payments, user: nil)
      StarkBank::Utils::Rest.post(entities: payments, user: user, **resource)
    end

    # # Retrieve a specific BrcodePayment
    #
    # Receive a single BrcodePayment object previously created by the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - BrcodePayment object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve a specific BrcodePayment pdf file
    #
    # Receive a single BrcodePayment pdf file generated in the Stark Bank API by passing its id.
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - BrcodePayment pdf file
    def self.pdf(id, user: nil)
      StarkBank::Utils::Rest.get_pdf(id: id, user: user, **resource)
    end

    # # Update a BrcodePayment entity
    #
    # Update a BrcodePayment entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: BrcodePayment unique id. ex: '5656565656565656'
    # - status [string, nil]: You may cancel the payment by passing 'canceled' in the status
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - updated BrcodePayment object
    def self.update(id, status: nil, user: nil)
      StarkBank::Utils::Rest.patch_id(id: id, status: status, user: user, **resource)
    end

    # # Retrieve BrcodePayments
    #
    # Receive a generator of BrcodePayment objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil] date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil] date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of strings to get specific entities by ids. ex: ['12376517623', '1928367198236']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'paid'
    # - user [Organization/Project object]: Organization or Project object. Not necessary if Starkbank.user was set before function call
    #
    # ## Return:
    # - generator of BrcodePayment objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, tags: nil, ids: nil, status: nil, user: nil)
      after = StarkBank::Utils::Checks.check_date(after)
      before = StarkBank::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_list(
        user: user,
        limit: limit,
        after: after,
        before: before,
        tags: tags,
        ids: ids,
        status: status,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'BrcodePayment',
        resource_maker: proc { |json|
          BrcodePayment.new(
            brcode: json['brcode'],
            tax_id: json['tax_id'],
            description: json['description'],
            amount: json['amount'],
            scheduled: json['scheduled'],
            tags: json['tags'],
            id: json['id'],
            name: json['name'],
            status: json['status'],
            type: json['type'],
            transaction_ids: json['transaction_ids'],
            fee: json['fee'],
            updated: json['updated'],
            created: json['created']
          )
        }
      }
    end
  end
end
