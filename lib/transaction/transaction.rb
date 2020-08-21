# frozen_string_literal: true

require_relative('../utils/resource')
require_relative('../utils/rest')
require_relative('../utils/checks')

module StarkBank
  # # Transaction object
  #
  # A Transaction is a transfer of funds between workspaces inside Stark Bank.
  # Transactions created by the user are only for internal transactions.
  # Other operations (such as transfer or charge-payment) will automatically
  # create a transaction for the user which can be retrieved for the statement.
  # When you initialize a Transaction, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - amount [integer]: amount in cents to be transferred. ex: 1234 (= R$ 12.34)
  # - description [string]: text to be displayed in the receiver and the sender statements (Min. 10 characters). ex: 'funds redistribution'
  # - external_id [string]: unique id, generated by user, to avoid duplicated transactions. ex: 'transaction ABC 2020-03-30'
  # - received_id [string]: unique id of the receiving workspace. ex: '5656565656565656'
  #
  # ## Parameters (optional):
  # - tags [list of strings]: list of strings for reference when searching transactions (may be empty). ex: ['abc', 'test']
  #
  # ## Attributes (return-only):
  # - sender_id [string]: unique id of the sending workspace. ex: '5656565656565656'
  # - source [string, default nil]: locator of the entity that generated the transaction. ex: 'charge/1827351876292', 'transfer/92873912873/chargeback'
  # - id [string, default nil]: unique id returned when Transaction is created. ex: '7656565656565656'
  # - fee [integer, default nil]: fee charged when transaction is created. ex: 200 (= R$ 2.00)
  # - balance [integer, default nil]: account balance after transaction was processed. ex: 100000000 (= R$ 1,000,000.00)
  # - created [DateTime, default nil]: creation datetime for the boleto. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class Transaction < StarkBank::Utils::Resource
    attr_reader :amount, :description, :external_id, :receiver_id, :sender_id, :tags, :id, :fee, :created, :source
    def initialize(amount:, description:, external_id:, receiver_id:, sender_id: nil, tags: nil, id: nil, fee: nil, source: nil, balance: nil, created: nil)
      super(id)
      @amount = amount
      @description = description
      @external_id = external_id
      @receiver_id = receiver_id
      @sender_id = sender_id
      @tags = tags
      @fee = fee
      @source = source
      @balance = balance
      @created = StarkBank::Utils::Checks.check_datetime(created)
    end

    # # Create Transactions
    #
    # Send a list of Transaction objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - transactions [list of Transaction objects]: list of Transaction objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of Transaction objects with updated attributes
    def self.create(transactions, user: nil)
      StarkBank::Utils::Rest.post(entities: transactions, user: user, **resource)
    end

    # # Retrieve a specific Transaction
    #
    # Receive a single Transaction object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Transaction object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve Transactions
    #
    # Receive a generator of Transaction objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil] date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil] date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - external_ids [list of strings, default nil]: list of external ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Project object, default nil]: Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of Transaction objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, tags: nil, external_ids: nil, user: nil)
      after = StarkBank::Utils::Checks.check_date(after)
      before = StarkBank::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_list(user: user, limit: limit, after: after, before: before, tags: tags, external_ids: external_ids, **resource)
    end

    def self.resource
      {
        resource_name: 'Transaction',
        resource_maker: proc { |json|
          Transaction.new(
            amount: json['amount'],
            description: json['description'],
            external_id: json['external_id'],
            receiver_id: json['receiver_id'],
            sender_id: json['sender_id'],
            tags: json['tags'],
            id: json['id'],
            fee: json['fee'],
            source: json['source'],
            balance: json['balance'],
            created: json['created']
          )
        }
      }
    end
  end
end
