# frozen_string_literal: true

require_relative('../utils/resource')
require_relative('../utils/rest')
require_relative('../utils/checks')

module StarkBank
  # # Deposit object
  #
  # Deposits represent passive cash-in received by your account from external transfers
  #
  ## Attributes (return-only):
  # - id [string]: unique id associated with a Deposit when it is created. ex: '5656565656565656'
  # - name [string]: payer name. ex: 'Iron Bank S.A.'
  # - tax_id [string]: payer tax ID (CPF or CNPJ). ex: '012.345.678-90' or '20.018.183/0001-80'
  # - bank_code [string]: payer bank code in Brazil. ex: '20018183' or '341'
  # - branch_code [string]: payer bank account branch. ex: '1357-9's
  # - account_number [string]: payer bank account number. ex: '876543-2'
  # - amount [integer]: Deposit value in cents. ex: 1234 (= R$ 12.34)
  # - type [string]: Type of settlement that originated the deposit. ex: 'pix' or 'ted'
  # - status [string]: current Deposit status. ex: 'created'
  # - tags [list of strings]: list of strings that are tagging the deposit. ex: ['reconciliationId', 'txId']
  # - fee [integer]: fee charged by this deposit. ex: 50 (= R$ 0.50)
  # - transaction_ids [list of strings]: ledger transaction ids linked to this Deposit (if there are more than one, all but first are reversals). ex: ['19827356981273']
  # - created [datetime.datetime]: creation datetime for the Deposit. ex: datetime.datetime(2020, 12, 10, 10, 30, 0, 0)
  # - updated [datetime.datetime]: latest update datetime for the Deposit. ex: datetime.datetime(2020, 12, 10, 10, 30, 0, 0)
  class Deposit < StarkBank::Utils::Resource
    attr_reader :id, :name, :tax_id, :bank_code, :branch_code, :account_number, :amount, :type, :status, :tags, :fee, :transaction_ids, :created, :updated
    def initialize(
      id:, name:, tax_id:, bank_code:, branch_code:, account_number:, amount:, type:, status:, tags:, fee:,
      transaction_ids:, created:, updated:
    )
      super(id)
      @name = name
      @tax_id = tax_id
      @bank_code = bank_code
      @branch_code = branch_code
      @account_number = account_number
      @amount = amount
      @type = type
      @status = status
      @tags = tags
      @fee = fee
      @transaction_ids = transaction_ids
      @created = StarkBank::Utils::Checks.check_datetime(created)
      @updated = StarkBank::Utils::Checks.check_datetime(updated)
    end

    # # Retrieve a specific Deposit
    #
    # Receive a single Deposit object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Deposit object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve Deposits
    #
    # Receive a generator of Deposit objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date , DateTime, Time or string, default nil] date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil] date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'paid' or 'registered'
    # - sort [string, default '-created']: sort order considered in response. Valid options are 'created' or '-created'.
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if Starkbank.user was set before function call
    #
    # ## Return:
    # - generator of Deposit objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, status: nil, sort: nil, tags: nil, ids: nil, user: nil)
      after = StarkBank::Utils::Checks.check_date(after)
      before = StarkBank::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_list(
        limit: limit,
        after: after,
        before: before,
        status: status,
        sort: sort,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'Deposit',
        resource_maker: proc { |json|
          Deposit.new(
            id: json['id'],
            name: json['name'],
            tax_id: json['tax_id'],
            bank_code: json['bank_code'],
            branch_code: json['branch_code'],
            account_number: json['account_number'],
            amount: json['amount'],
            type: json['type'],
            status: json['status'],
            tags: json['tags'],
            fee: json['fee'],
            transaction_ids: json['transaction_ids'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
