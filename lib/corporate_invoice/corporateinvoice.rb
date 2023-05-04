# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # CorporateInvoice object
  #
  # The CorporateInvoice objects created in your Workspace load your Corporate balance when paid.
  #
  # When you initialize a CorporateInvoice, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the created object.
  #
  # ## Parameters (required):
  # - amount [integer]: CorporateInvoice value in cents. ex: 1234 (= R$ 12.34)
  #
  # ## Parameters (optional):
  # - tags [list of strings, default nil]: list of strings for tagging. ex: ['travel', 'food']
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when CorporateInvoice is created. ex: '5656565656565656'
  # - name [string, default sub-issuer name]: payer name. ex: 'Iron Bank S.A.'
  # - tax_id [string, default sub-issuer tax ID]: payer tax ID (CPF or CNPJ) with or without formatting. ex: '01234567890' or '20.018.183/0001-80'
  # - brcode [string]: BR Code for the Invoice payment. ex: '00020101021226930014br.gov.bcb.pix2571brcode-h.development.starkbank.com/v2/d7f6546e194d4c64a153e8f79f1c41ac5204000053039865802BR5925Stark Bank S.A. - Institu6009Sao Paulo62070503***63042109'
  # - due [DateTime, Date or string]: Invoice due and expiration date in UTC ISO format. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0), Date.new(2020, 3, 10) or '2020-03-10T10:30:00.000000+00:00'
  # - link [string]: public Invoice webpage URL. ex: 'https://starkbank-card-issuer.development.starkbank.com/invoicelink/d7f6546e194d4c64a153e8f79f1c41ac'
  # - status [string]: current CorporateInvoice status. ex: 'created', 'expired', 'overdue', 'paid'
  # - corporate_transaction_id [string]: ledger transaction ids linked to this CorporateInvoice. ex: 'corporate-invoice/5656565656565656'
  # - updated [DateTime]: latest update datetime for the CorporateInvoice. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - created [DateTime]: creation datetime for the CorporateInvoice. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class CorporateInvoice < StarkCore::Utils::Resource
    attr_reader :id, :amount, :tax_id, :name, :tags, :brcode, :due, :link, :status, :corporate_transaction_id, :updated, :created
    def initialize(
      amount:, id: nil, tax_id: nil, name: nil, tags: nil, brcode: nil, due: nil, link: nil, status: nil, corporate_transaction_id: nil,
      updated: nil, created: nil
    )
      super(id)
      @amount = amount
      @tax_id = tax_id
      @name = name
      @tags = tags
      @brcode = brcode
      @due = due
      @link = link
      @status = status
      @corporate_transaction_id = corporate_transaction_id
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
      @created = StarkCore::Utils::Checks.check_datetime(created)
    end

    # # Create a CorporateInvoice
    #
    # Send a single CorporateInvoice object for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - invoice [CorporateInvoice object]: CorporateInvoice object to be created in the API.
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - CorporateInvoice object with updated attributes
    def self.create(invoice, user: nil)
      StarkBank::Utils::Rest.post_single(entity: invoice, user: user, **resource)
    end

    # # Retrieve CorporateInvoices
    #
    # Receive a generator of CorporateInvoices objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [list of strings, default nil]: filter for status of retrieved objects. ex: ['created', 'expired', 'overdue', 'paid']
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of CorporateInvoices objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, status: nil, tags: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        user: user,
        **resource
      )
    end

    # # Retrieve paged CorporateInvoices
    #
    # Receive a list of up to 100 CorporateInvoices objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your logs.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call.
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [list of strings, default nil]: filter for status of retrieved objects. ex: ['created', 'expired', 'overdue', 'paid']
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of CorporateInvoice objects with updated attributes
    # - cursor to retrieve the next page of CorporateInvoice objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, status: nil, tags: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'CorporateInvoice',
        resource_maker: proc { |json|
          CorporateInvoice.new(
            id: json['id'],
            amount: json['amount'],
            tax_id: json['tax_id'],
            name: json['name'],
            tags: json['tags'],
            brcode: json['brcode'],
            due: json['due'],
            link: json['link'],
            status: json['status'],
            corporate_transaction_id: json['corporate_transaction_id'],
            updated: json['updated'],
            created: json['created']
          )
        }
      }
    end
  end
end
