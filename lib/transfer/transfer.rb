# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')


module StarkBank
  # # Transfer object
  #
  # When you initialize a Transfer, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - amount [integer]: amount in cents to be transferred. ex: 1234 (= R$ 12.34)
  # - name [string]: receiver full name. ex: 'Anthony Edward Stark'
  # - tax_id [string]: receiver tax ID (CPF or CNPJ) with or without formatting. ex: '01234567890' or '20.018.183/0001-80'
  # - bank_code [string]: code of the receiver bank institution in Brazil. If an ISPB (8 digits) is informed, a PIX transfer will be created, else a TED will be issued. ex: '20018183' or '260'
  # - branch_code [string]: receiver bank account branch. Use '-' in case there is a verifier digit. ex: '1357-9'
  # - account_number [string]: receiver bank account number. Use '-' before the verifier digit. ex: '876543-2'
  #
  # ## Parameters (optional):
  # - account_type [string, default 'checking']: receiver bank account type. This parameter only has effect on Pix Transfers. ex: 'checking', 'savings', 'salary' or 'payment'
  # - external_id [string, default nil]: url safe string that must be unique among all your transfers. Duplicated external_ids will cause failures. By default, this parameter will block any transfer that repeats amount and receiver information on the same date. ex: 'my-internal-id-123456'
  # - scheduled [string, default now]: datetime when the transfer will be processed. May be pushed to next business day if necessary. ex: DateTime.new(2020, 3, 11, 8, 13, 12, 11)
  # - description [string, default nil]: optional description to override default description to be shown in the bank statement. ex: 'Payment for service #1234'
  # - tags [list of strings]: list of strings for reference when searching for transfers. ex: ['employees', 'monthly']
  # - rules [list of Transfer::Rules, default []]: list of Transfer::Rule objects for modifying transfer behavior. ex: [Transfer::Rule(key: "resendingLimit", value: 5)]
  #
  # ## Attributes (return-only):
  # - id [string, default nil]: unique id returned when Transfer is created. ex: '5656565656565656'
  # - fee [integer, default nil]: fee charged when transfer is created. ex: 200 (= R$ 2.00)
  # - status [string, default nil]: current transfer status. ex: 'success' or 'failed'
  # - transaction_ids [list of strings, default nil]: ledger transaction ids linked to this transfer (if there are two, second is the chargeback). ex: ['19827356981273']
  # - created [DateTime, default nil]: creation datetime for the transfer. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime, default nil]: latest update datetime for the transfer. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class Transfer < StarkCore::Utils::Resource
    attr_reader :amount, :name, :tax_id, :bank_code, :branch_code, :account_number, :account_type, :external_id, :scheduled, :description, :transaction_ids, :fee, :tags, :rules, :status, :id, :created, :updated
    def initialize(amount:, name:, tax_id:, bank_code:, branch_code:, account_number:, account_type: nil, external_id: nil, scheduled: nil, description: nil, transaction_ids: nil, fee: nil, tags: nil, rules: nil, status: nil, id: nil, created: nil, updated: nil)
      super(id)
      @amount = amount
      @name = name
      @tax_id = tax_id
      @bank_code = bank_code
      @branch_code = branch_code
      @account_number = account_number
      @account_type = account_type
      @external_id = external_id
      @scheduled = StarkCore::Utils::Checks.check_date_or_datetime(scheduled)
      @description = description
      @tags = tags
      @rules = StarkBank::Transfer::Rule.parse_rules(rules)
      @fee = fee
      @status = status
      @transaction_ids = transaction_ids
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create Transfers
    #
    # Send a list of Transfer objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - transfers [list of Transfer objects]: list of Transfer objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of Transfer objects with updated attributes
    def self.create(transfers, user: nil)
      StarkBank::Utils::Rest.post(entities: transfers, user: user, **resource)
    end

    # # Retrieve a specific Transfer
    #
    # Receive a single Transfer object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Transfer object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Delete a Transfer entity
    #
    # Delete a Transfer entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: Transfer unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - deleted Transfer object
    def self.delete(id, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    # # Retrieve a specific Transfer pdf file
    #
    # Receive a single Transfer pdf receipt file generated in the Stark Bank API by passing its id.
    # Only valid for transfers with 'processing' and 'success' status.
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Transfer pdf file
    def self.pdf(id, user: nil)
      StarkBank::Utils::Rest.get_content(id: id, user: user, sub_resource_name: 'pdf', **resource)
    end

    # # Retrieve Transfers
    #
    # Receive a generator of Transfer objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created or updated only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created or updated only before specified date. ex: Date.new(2020, 3, 10)
    # - transactionIds [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'success' or 'failed'
    # - tax_id [string, default nil]: filter for transfers sent to the specified tax ID. ex: '012.345.678-90'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of Transfer objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, transaction_ids: nil, status: nil, tax_id: nil, sort: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        transaction_ids: transaction_ids,
        status: status,
        tax_id: tax_id,
        sort: sort,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    # # Retrieve paged Transfers
    #
    # Receive a list of up to 100 Transfer objects previously created in the Stark Bank API and the cursor to the next page.
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
    # - list of Transfer objects with updated attributes and cursor to retrieve the next page of Transfer objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, transaction_ids: nil, status: nil, tax_id: nil, sort: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        transaction_ids: transaction_ids,
        status: status,
        tax_id: tax_id,
        sort: sort,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'Transfer',
        resource_maker: proc { |json|
          Transfer.new(
            amount: json['amount'],
            name: json['name'],
            tax_id: json['tax_id'],
            bank_code: json['bank_code'],
            branch_code: json['branch_code'],
            account_number: json['account_number'],
            account_type: json['account_type'],
            external_id: json['external_id'],
            scheduled: json['scheduled'],
            description: json['description'],
            tags: json['tags'],
            rules: json['rules'],
            id: json['id'],
            fee: json['fee'],
            status: json['status'],
            transaction_ids: json['transaction_ids'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
