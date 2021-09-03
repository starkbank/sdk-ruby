# frozen_string_literal: true

require_relative('../utils/resource')
require_relative('../utils/rest')
require_relative('../utils/checks')

module StarkBank
  # # Invoice object
  #
  # When you initialize an Invoice, the entity will not be automatically
  # sent to the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  # To create scheduled Invoices, which will display the discount, interest, etc. on the final users banking interface,
  # use dates instead of datetimes on the "due" and "discounts" fields.
  #
  # ## Parameters (required):
  # - amount [integer]: Invoice value in cents. Minimum = 0 (any value will be accepted). ex: 1234 (= R$ 12.34)
  # - tax_id [string]: payer tax ID (CPF or CNPJ) with or without formatting. ex: '01234567890' or '20.018.183/0001-80'
  # - name [string]: payer name. ex: 'Iron Bank S.A.'
  #
  # ## Parameters (optional):
  # - due [DateTime or string, default now + 2 days]: Invoice due date in UTC ISO format. ex: '2020-10-28T17:59:26.249976+00:00'
  # - expiration [integer, default 5097600 (59 days)]: time interval in seconds between due date and expiration date. ex 123456789
  # - fine [float, default 0.0]: Invoice fine for overdue payment in %. ex: 2.5
  # - interest [float, default 0.0]: Invoice monthly interest for overdue payment in %. ex: 5.2
  # - discounts [list of hashes, default nil]: list of hashes with 'percentage':float and 'due':DateTime or string pairs
  # - descriptions [list of hashes, default nil]: list of hashes with 'key':string and 'value':string pairs
  # - tags [list of strings, default nil]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - pdf [string, default nil]: public Invoice PDF URL. ex: 'https://invoice.starkbank.com/pdf/d454fa4e524441c1b0c1a729457ed9d8'
  # - link [string, default nil]: public Invoice webpage URL. ex: 'https://my-workspace.sandbox.starkbank.com/invoicelink/d454fa4e524441c1b0c1a729457ed9d8'
  # - id [string, default nil]: unique id returned when Invoice is created. ex: '5656565656565656'
  # - nominal_amount [integer, default nil]: Invoice emission value in cents (will change if invoice is updated, but not if it's paid). ex: 400000
  # - fine_amount [integer, default nil]: Invoice fine value calculated over nominal_amount. ex: 20000
  # - interest_amount [integer, default nil]: Invoice interest value calculated over nominal_amount. ex: 10000
  # - discount_amount [integer, default nil]: Invoice discount value calculated over nominal_amount. ex: 3000
  # - brcode [string, default nil]: BR Code for the Invoice payment. ex: '00020101021226800014br.gov.bcb.pix2558invoice.starkbank.com/f5333103-3279-4db2-8389-5efe335ba93d5204000053039865802BR5913Arya Stark6009Sao Paulo6220051656565656565656566304A9A0'
  # - fee [integer, default nil]: fee charged by the Invoice. ex: 65 (= R$ 0.65)
  # - status [string, default nil]: current Invoice status. ex: 'registered' or 'paid'
  # - created [DateTime, default nil]: creation datetime for the Invoice. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime, default nil]: latest update datetime for the Invoice. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class Invoice < StarkBank::Utils::Resource
    attr_reader :amount, :tax_id, :name, :due, :expiration, :fine, :interest, :discounts, :tags, :pdf, :link, :descriptions, :nominal_amount, :fine_amount, :interest_amount, :discount_amount, :id, :brcode, :fee, :status, :transaction_ids, :created, :updated
    def initialize(
      amount:, tax_id:, name:, due: nil, expiration: nil, fine: nil, interest: nil, discounts: nil,
      tags: nil, pdf: nil, link: nil, descriptions: nil, nominal_amount: nil, fine_amount: nil, interest_amount: nil,
      discount_amount: nil, id: nil, brcode: nil, fee: nil, status: nil, transaction_ids: nil, created: nil, updated: nil
    )
      super(id)
      @amount = amount
      @due = StarkBank::Utils::Checks.check_date_or_datetime(due)
      @tax_id = tax_id
      @name = name
      @expiration = expiration
      @fine = fine
      @interest = interest
      @tags = tags
      @pdf = pdf
      @link = link
      @descriptions = descriptions
      @nominal_amount = nominal_amount
      @fine_amount = fine_amount
      @interest_amount = interest_amount
      @discount_amount = discount_amount
      @brcode = brcode
      @fee = fee
      @status = status
      @transaction_ids = transaction_ids
      @updated = StarkBank::Utils::Checks.check_datetime(updated)
      @created = StarkBank::Utils::Checks.check_datetime(created)
      if !discounts.nil?
        checked_discounts = []
        discounts.each do |discount|
          discount["due"] = StarkBank::Utils::Checks.check_datetime(discount["due"])
          checked_discounts.push(discount)
        end
        @discounts = checked_discounts
      end
    end

    # # Create Invoices
    #
    # Send a list of Invoice objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - invoices [list of Invoice objects]: list of Invoice objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of Invoice objects with updated attributes
    def self.create(invoices, user: nil)
      StarkBank::Utils::Rest.post(entities: invoices, user: user, **resource)
    end

    # # Retrieve a specific Invoice
    #
    # Receive a single Invoice object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Invoice object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve a specific Invoice pdf file
    #
    # Receive a single Invoice pdf file generated in the Stark Bank API by passing its id.
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Invoice pdf file
    def self.pdf(id, user: nil)
      StarkBank::Utils::Rest.get_content(id: id, user: user, sub_resource_name: 'pdf', **resource)
    end

    # # Retrieve a specific Invoice QR Code file
    #
    # Receive a single Invoice QR Code png file generated in the Stark Bank API by passing its id.
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Invoice QR Code png blob
    def self.qrcode(id, user: nil)
      StarkBank::Utils::Rest.get_content(id: id, user: user, sub_resource_name: 'qrcode', **resource)
    end

    # # Retrieve Invoices
    #
    # Receive a generator of Invoice objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'paid' or 'registered'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of Invoice objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, user: nil)
      after = StarkBank::Utils::Checks.check_date(after)
      before = StarkBank::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    # # Retrieve paged Invoices
    #
    # Receive a list of up to 100 Invoice objects previously created in the Stark Bank API and the cursor to the next page.
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
    # - list of Invoice objects with updated attributes and cursor to retrieve the next page of Invoice objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, user: nil)
      after = StarkBank::Utils::Checks.check_date(after)
      before = StarkBank::Utils::Checks.check_date(before)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    # # Update an Invoice entity
    #
    # Update an Invoice entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: Invoice unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - status [string, nil]: You may cancel the invoice by passing 'canceled' in the status
    # - amount [string, nil]: Nominal amount charged by the invoice. ex: 100 (R$1.00)
    # - due [datetime.date or string, default nil]: Invoice due date in UTC ISO format. ex: DateTime.new(2020, 3, 10, 10, 30, 12, 21)
    # - expiration [number, default nil]: time interval in seconds between the due date and the expiration date. ex 123456789
    #
    # ## Return:
    # - updated Invoice object
    def self.update(id, status: nil, amount: nil, due: nil, expiration: nil, user: nil)
      StarkBank::Utils::Rest.patch_id(id: id, status: status, amount: amount, due: due, expiration: expiration, user: user, **resource)
    end

    # # Retrieve a specific Invoice payment information
    #
    # Receive the Invoice::Payment sub-resource associated with a paid Invoice.
    #
    # ## Parameters (required):
    # - id [string]: Invoice unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Invoice::Payment sub-resource
    def self.payment(id, user: nil)
      StarkBank::Utils::Rest.get_sub_resource(id: id, user: user, **resource, **StarkBank::Invoice::Payment.resource)
    end

    def self.resource
      {
        resource_name: 'Invoice',
        resource_maker: proc { |json|
          Invoice.new(
            id: json['id'],
            amount: json['amount'],
            due: json['due'],
            tax_id: json['tax_id'],
            name: json['name'],
            expiration: json['expiration'],
            fine: json['fine'],
            interest: json['interest'],
            discounts: json['discounts'],
            tags: json['tags'],
            pdf: json['pdf'],
            link: json['link'],
            descriptions: json['descriptions'],
            nominal_amount: json['nominal_amount'],
            fine_amount: json['fine_amount'],
            interest_amount: json['interest_amount'],
            discount_amount: json['discount_amount'],
            brcode: json['brcode'],
            fee: json['fee'],
            status: json['status'],
            transaction_ids: json['transaction_ids'],
            updated: json['updated'],
            created: json['created'],
          )
        }
      }
    end
  end
end
