# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # InvoicePullSubscription object
  #
  # When you initialize an InvoicePullSubscription, the entity will not be automatically sent to the Stark Bank API.
  # The 'create' function sends the objects to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - start [Date, DateTime or string]: subscription start date. ex: '2022-04-01'
  # - interval [string]: subscription installment interval. Options: 'week', 'month', 'quarter', 'semester', 'year'
  # - pull_mode [string]: subscription pull mode. Options: 'manual', 'automatic'. Automatic mode will create the InvoicePullRequests automatically
  # - pull_retry_limit [integer]: subscription pull retry limit. Options: 0 or 3
  # - type [string]: subscription type. Options: 'push', 'qrcode', 'qrcodeAndPayment', 'paymentAndOrQrcode'
  #
  # ## Parameters (conditionally required):
  # - amount [integer, default 0]: subscription amount in cents. Required if amount_min_limit is not informed. Minimum = 1 (R$ 0.01). ex: 100 (= R$ 1.00)
  # - amount_min_limit [integer, default nil]: subscription minimum amount in cents. Required if amount is not informed. Minimum = 1 (R$ 0.01). ex: 100 (= R$ 1.00)
  #
  # ## Parameters (optional):
  # - display_description [string, default nil]: Invoice description to be shown to the payer. ex: 'Subscription payment'
  # - due [Date, DateTime or string, default now + 2 days]: date by which the payer must approve or deny the subscription, after which it auto-expires if unanswered. Applies to all subscription types (not push-only). ex: '2022-04-08'
  # - external_id [string, default nil]: string that must be unique among all your subscriptions. Duplicated external_ids will cause failures. ex: 'my-external-id'
  # - reference_code [string, default nil]: reference code for reconciliation. ex: 'REF123456'
  # - end [Date, DateTime or string, default nil]: subscription end date. ex: '2023-04-01'
  # - data [dictionary, default nil]: additional data required by type: payer account details for 'push', immediate-payment parameters for 'qrcodeAndPayment'/'paymentAndOrQrcode'; not required for 'qrcode'
  # - name [string, default nil]: subscription debtor name. ex: 'Iron Bank S.A.'
  # - tax_id [string, default nil]: subscription debtor tax ID (CPF or CNPJ) with or without formatting. ex: '01234567890' or '20.018.183/0001-80'
  # - tags [list of strings, default []]: list of strings for tagging. ex: ['travel', 'food']
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when InvoicePullSubscription is created. ex: '5656565656565656'
  # - status [string]: current InvoicePullSubscription status. ex: 'active', 'canceled', 'created', 'expired'
  # - bacen_id [string]: unique authentication id at the Central Bank. ex: 'RR2001818320250616dtsPkBVaBYs'
  # - brcode [string]: Brcode string for the InvoicePullSubscription. ex: '00020101021126580014br.gov.bcb.pix0114+5599999999990210starkbank.com.br520400005303986540410000000000005802BR5913Stark Bank S.A.6009SAO PAULO62070503***6304D2B1'
  # - installment_id [string]: unique id of the installment related to this subscription. ex: '5656565656565656'
  # - created [DateTime]: creation datetime for the InvoicePullSubscription. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: latest update datetime for the InvoicePullSubscription. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class InvoicePullSubscription < StarkCore::Utils::Resource
    attr_reader :start, :interval, :pull_mode, :pull_retry_limit, :type, :amount, :amount_min_limit, :display_description,
                :due, :external_id, :reference_code, :end, :data, :name, :tax_id, :tags, :id, :status, :bacen_id,
                :brcode, :installment_id, :created, :updated
    def initialize(
      start:, interval:, pull_mode:, pull_retry_limit:, type:, amount: nil, amount_min_limit: nil, display_description: nil,
      due: nil, external_id: nil, reference_code: nil, end_: nil, data: nil, name: nil, tax_id: nil, tags: nil,
      id: nil, status: nil, bacen_id: nil, brcode: nil, installment_id: nil, created: nil, updated: nil
    )
      super(id)
      @start = StarkCore::Utils::Checks.check_date_or_datetime(start)
      @interval = interval
      @pull_mode = pull_mode
      @pull_retry_limit = pull_retry_limit
      @type = type
      @amount = amount
      @amount_min_limit = amount_min_limit
      @display_description = display_description
      @due = StarkCore::Utils::Checks.check_date_or_datetime(due)
      @external_id = external_id
      @reference_code = reference_code
      @end = StarkCore::Utils::Checks.check_date_or_datetime(end_)
      @data = data
      @name = name
      @tax_id = tax_id
      @tags = tags
      @status = status
      @bacen_id = bacen_id
      @brcode = brcode
      @installment_id = installment_id
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create InvoicePullSubscriptions
    #
    # Send a list of InvoicePullSubscription objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - subscriptions [list of InvoicePullSubscription objects]: list of InvoicePullSubscription objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of InvoicePullSubscription objects with updated attributes
    def self.create(subscriptions, user: nil)
      StarkBank::Utils::Rest.post(entities: subscriptions, user: user, **resource)
    end

    # # Retrieve a specific InvoicePullSubscription
    #
    # Receive a single InvoicePullSubscription object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - InvoicePullSubscription object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve InvoicePullSubscriptions
    #
    # Receive a generator of InvoicePullSubscription objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created or updated only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created or updated only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['travel', 'food']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - invoice_ids [list of strings, default nil]: list of Invoice ids linked to the subscriptions. ex: ['5656565656565656', '4545454545454545']
    # - external_ids [list of strings, default nil]: list of external_ids to filter retrieved objects. ex: ['my-external-id-1', 'my-external-id-2']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'active', 'canceled', 'created', 'expired'
    # - expand [list of strings, default nil]: fields to expand information. ex: ['data']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of InvoicePullSubscription objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, tags: nil, ids: nil, invoice_ids: nil, external_ids: nil, status: nil, expand: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        tags: tags,
        ids: ids,
        invoice_ids: invoice_ids,
        external_ids: external_ids,
        status: status,
        expand: expand,
        user: user,
        **resource
      )
    end

    # # Retrieve paged InvoicePullSubscriptions
    #
    # Receive a list of up to 100 InvoicePullSubscription objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created or updated only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created or updated only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['travel', 'food']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - invoice_ids [list of strings, default nil]: list of Invoice ids linked to the subscriptions. ex: ['5656565656565656', '4545454545454545']
    # - external_ids [list of strings, default nil]: list of external_ids to filter retrieved objects. ex: ['my-external-id-1', 'my-external-id-2']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'active', 'canceled', 'created', 'expired'
    # - expand [list of strings, default nil]: fields to expand information. ex: ['data']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of InvoicePullSubscription objects with updated attributes and cursor to retrieve the next page of InvoicePullSubscription objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, tags: nil, ids: nil, invoice_ids: nil, external_ids: nil, status: nil, expand: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        tags: tags,
        ids: ids,
        invoice_ids: invoice_ids,
        external_ids: external_ids,
        status: status,
        expand: expand,
        user: user,
        **resource
      )
    end

    # # Cancel an InvoicePullSubscription entity
    #
    # Cancel an InvoicePullSubscription entity previously created in the Stark Bank API. The subscription must
    # currently have 'active' status to be canceled.
    #
    # ## Parameters (required):
    # - id [string]: InvoicePullSubscription unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - canceled InvoicePullSubscription object
    def self.cancel(id, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'InvoicePullSubscription',
        resource_maker: proc { |json|
          InvoicePullSubscription.new(
            id: json['id'],
            start: json['start'],
            interval: json['interval'],
            pull_mode: json['pull_mode'],
            pull_retry_limit: json['pull_retry_limit'],
            type: json['type'],
            amount: json['amount'],
            amount_min_limit: json['amount_min_limit'],
            display_description: json['display_description'],
            due: json['due'],
            external_id: json['external_id'],
            reference_code: json['reference_code'],
            end_: json['end'],
            data: json['data'],
            name: json['name'],
            tax_id: json['tax_id'],
            tags: json['tags'],
            status: json['status'],
            bacen_id: json['bacen_id'],
            brcode: json['brcode'],
            installment_id: json['installment_id'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
