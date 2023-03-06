# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')


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
  # - rules [list of BrcodePayment::Rules, default []]: list of BrcodePayment::Rule objects for modifying transfer behavior. ex: [BrcodePayment::Rule(key: "resendingLimit", value: 5)]
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when payment is created. ex: '5656565656565656'
  # - name [string]: receiver name. ex: 'Jon Snow'
  # - status [string]: current payment status. ex: 'success' or 'failed'
  # - type [string]: brcode type. ex: 'static' or 'dynamic'
  # - transaction_ids [list of strings]: ledger transaction ids linked to this payment. ex: ['19827356981273']
  # - fee [integer]: fee charged when the brcode payment is created. ex: 200 (= R$ 2.00)
  # - updated [datetime.datetime]: latest update datetime for the payment. ex: datetime.datetime(2020, 3, 10, 10, 30, 0, 0)
  # - created [datetime.datetime]: creation datetime for the payment. ex: datetime.datetime(2020, 3, 10, 10, 30, 0, 0)
  class BrcodePayment < StarkCore::Utils::Resource
    attr_reader :brcode, :tax_id, :description, :amount, :scheduled, :tags, :rules, :id, :name, :status, :type, :transaction_ids, :fee, :updated, :created
    def initialize(brcode:, tax_id:, description:, amount: nil, scheduled: nil, tags: nil, rules: nil, id: nil, name: nil, status: nil, type: nil, transaction_ids: nil, fee: nil, updated: nil, created: nil)
      super(id)
      @brcode = brcode
      @tax_id = tax_id
      @description = description
      @amount = amount
      @scheduled = StarkCore::Utils::Checks.check_date_or_datetime(scheduled)
      @tags = tags
      @rules = StarkBank::BrcodePayment::Rule.parse_rules(rules)
      @name = name
      @status = status
      @type = type
      @transaction_ids = transaction_ids
      @fee = fee
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
      @created = StarkCore::Utils::Checks.check_datetime(created)
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
      StarkBank::Utils::Rest.get_content(id: id, user: user, sub_resource_name: 'pdf', **resource)
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
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of strings to get specific entities by ids. ex: ['12376517623', '1928367198236']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'paid'
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of BrcodePayment objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, tags: nil, ids: nil, status: nil, user: nil)
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

    # # Retrieve paged BrcodePayments
    #
    # Receive a list of up to 100 BrcodePayment objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of strings to get specific entities by ids. ex: ['12376517623', '1928367198236']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'paid'
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of BrcodePayment objects with updated attributes and cursor to retrieve the next page of BrcodePayment objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, tags: nil, ids: nil, status: nil, user: nil)
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
            rules: json['rules'],
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
