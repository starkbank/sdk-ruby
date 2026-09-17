# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')
require_relative('../transfer/rule')


module StarkBank
  # # VerifiedTransfer object
  #
  # When you initialize a VerifiedTransfer, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - amount [integer]: transfer value in cents. ex: 1234 (= R$ 12.34)
  # - account_id [string]: receiver's VerifiedAccount ID. ex: '5656565656565656'
  #
  # ## Parameters (optional):
  # - external_id [string, default nil]: url safe string that must be unique among all your transfers. Duplicated external_ids will cause failures. By default, this parameter will block any transfer that repeats amount and receiver information on the same date. ex: 'my-internal-id-123456'
  # - scheduled [DateTime or string, default now]: date or datetime when the transfer will be processed. May be pushed to next business day if necessary. ex: '2020-11-12T00:14:22.806+00:00' or '2020-11-30'
  # - description [string, default nil]: optional description to override default description to be shown in the bank statement. ex: 'Payment for service #1234'
  # - display_description [string, default nil]: optional description to be shown in the receiver bank interface. ex: 'Payment for service #1234'
  # - tags [list of strings, default nil]: list of strings for reference when searching for verified transfers. ex: ['employees', 'monthly']
  # - rules [list of Transfer::Rule, default []]: list of Transfer::Rule objects for modifying transfer behavior. ex: [Transfer::Rule(key: 'resendingLimit', value: 5)]
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when the VerifiedTransfer is created. ex: '5656565656565656'
  # - fee [integer]: fee charged when the transfer is created. ex: 200 (= R$ 2.00)
  # - status [string]: current verified transfer status. ex: 'created', 'processing', 'success' or 'failed'
  # - transaction_ids [list of strings]: ledger transaction ids linked to this transfer (if there are two, second is the chargeback). ex: ['19827356981273']
  # - metadata [dictionary object]: dictionary object used to store additional information about the VerifiedTransfer object.
  # - created [DateTime]: creation datetime for the verified transfer. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: update datetime for the verified transfer. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class VerifiedTransfer < StarkCore::Utils::Resource
    attr_reader :amount, :account_id, :external_id, :scheduled, :description, :display_description, :tags, :rules, :id, :fee, :status, :transaction_ids, :metadata, :created, :updated
    def initialize(
      amount:, account_id:, external_id: nil, scheduled: nil, description: nil,
      display_description: nil, tags: nil, rules: nil, id: nil, fee: nil, status: nil,
      transaction_ids: nil, metadata: nil, created: nil, updated: nil
    )
      super(id)
      @amount = amount
      @account_id = account_id
      @external_id = external_id
      @scheduled = StarkCore::Utils::Checks.check_date_or_datetime(scheduled)
      @description = description
      @display_description = display_description
      @tags = tags
      @rules = StarkBank::Transfer::Rule.parse_rules(rules)
      @fee = fee
      @status = status
      @transaction_ids = transaction_ids
      @metadata = metadata
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create VerifiedTransfers
    #
    # Send a list of VerifiedTransfer objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - verified_transfers [list of VerifiedTransfer objects]: list of VerifiedTransfer objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of VerifiedTransfer objects with updated attributes
    def self.create(verified_transfers, user: nil)
      StarkBank::Utils::Rest.post(entities: verified_transfers, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'VerifiedTransfer',
        resource_maker: proc { |json|
          VerifiedTransfer.new(
            id: json['id'],
            amount: json['amount'],
            account_id: json['account_id'],
            external_id: json['external_id'],
            scheduled: json['scheduled'],
            description: json['description'],
            display_description: json['display_description'],
            tags: json['tags'],
            rules: json['rules'],
            fee: json['fee'],
            status: json['status'],
            transaction_ids: json['transaction_ids'],
            metadata: json['metadata'],
            created: json['created'],
            updated: json['updated'],
          )
        }
      }
    end
  end
end
