# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # MerchantInstallment object
  #
  # Represents one installment of a MerchantPurchase, generated automatically by the Stark Bank API when the
  # purchase is split.
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when MerchantInstallment is created. ex: '5656565656565656'
  # - amount [integer]: MerchantInstallment value in cents. ex: 1234 (= R$ 12.34)
  # - due [DateTime or Date]: MerchantInstallment due date. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - fee [integer]: fee charged when the MerchantInstallment is processed. ex: 200 (= R$ 2.00)
  # - funding_type [string]: installment funding type. ex: 'credit'
  # - network [string]: card network flag. ex: 'visa', 'mastercard'
  # - purchase_id [string]: unique id of the MerchantPurchase to which this installment belongs. ex: '5656565656565656'
  # - status [string]: current MerchantInstallment status. ex: 'created', 'success', 'failed'
  # - tags [list of strings]: list of strings for tagging
  # - transaction_ids [list of strings]: ledger transaction ids linked to this MerchantInstallment
  # - created [DateTime]: creation datetime for the MerchantInstallment. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: latest update datetime for the MerchantInstallment. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class MerchantInstallment < StarkCore::Utils::Resource
    attr_reader :id, :amount, :due, :fee, :funding_type, :network, :purchase_id, :status, :tags, :transaction_ids,
                :created, :updated
    def initialize(
      id: nil, amount: nil, due: nil, fee: nil, funding_type: nil, network: nil, purchase_id: nil, status: nil,
      tags: nil, transaction_ids: nil, created: nil, updated: nil
    )
      super(id)
      @amount = amount
      @due = StarkCore::Utils::Checks.check_date_or_datetime(due)
      @fee = fee
      @funding_type = funding_type
      @network = network
      @purchase_id = purchase_id
      @status = status
      @tags = tags
      @transaction_ids = transaction_ids
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Retrieve a specific MerchantInstallment
    #
    # Receive a single MerchantInstallment object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - MerchantInstallment object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve MerchantInstallments
    #
    # Receive a generator of MerchantInstallment objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'success'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - purchase_ids [list of strings, default nil]: list of MerchantPurchase ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of MerchantInstallment objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, purchase_ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        purchase_ids: purchase_ids,
        user: user,
        **resource
      )
    end

    # # Retrieve paged MerchantInstallments
    #
    # Receive a list of up to 100 MerchantInstallment objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'success'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - purchase_ids [list of strings, default nil]: list of MerchantPurchase ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of MerchantInstallment objects with updated attributes
    # - cursor to retrieve the next page of MerchantInstallment objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, purchase_ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        purchase_ids: purchase_ids,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'MerchantInstallment',
        resource_maker: proc { |json|
          MerchantInstallment.new(
            id: json['id'],
            amount: json['amount'],
            due: json['due'],
            fee: json['fee'],
            funding_type: json['funding_type'],
            network: json['network'],
            purchase_id: json['purchase_id'],
            status: json['status'],
            tags: json['tags'],
            transaction_ids: json['transaction_ids'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
