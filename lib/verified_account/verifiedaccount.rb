# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')


module StarkBank
  # # VerifiedAccount object
  #
  # When you initialize a VerifiedAccount, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - tax_id [string]: receiver tax ID (CPF or CNPJ) with or without formatting. ex: '01234567890' or '20.018.183/0001-80'
  #
  # ## Parameters (conditionally required):
  # - bank_code [string]: code of the receiver bank institution in Brazil. If an ISPB (8 digits) is informed, a Pix transfer will be created, else a TED will be issued. The bank_code parameter is required if verifying with bank details. ex: '20018183' or '341'
  # - branch_code [string]: receiver bank account branch. Use '-' in case there is a verifier digit. ex: '1357-9'. The branch_code parameter is required if verifying with bank details.
  # - key_id [string]: pix key identifier. ex: 'tony@starkbank.com', '012.345.678-90'. The key_id parameter is required if verifying with Pix key.
  # - name [string]: receiver full name. ex: 'Anthony Edward Stark'. The name parameter is required if verifying with bank details.
  # - number [string]: receiver bank account number. Use '-' before the verifier digit. ex: '876543-2'. The number parameter is required if verifying with bank details.
  # - type [string]: verified account type. ex: 'checking', 'savings', 'salary' or 'payment'. The type parameter is required if verifying with bank details.
  #
  # ## Parameters (optional):
  # - tags [list of strings, default nil]: list of strings for reference when searching for verified accounts. ex: ['employees', 'monthly']
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when the VerifiedAccount is created. ex: '5656565656565656'
  # - bank_name [string]: bank name associated with the verified account. ex: 'Stark Bank'
  # - status [string]: current verified account status. ex: 'creating', 'created', 'processing', 'active', 'failed' or 'canceled'
  # - created [DateTime]: creation datetime for the verified account. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: update datetime for the verified account. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class VerifiedAccount < StarkCore::Utils::Resource
    attr_reader :tax_id, :bank_code, :branch_code, :key_id, :name, :number, :type, :tags, :id, :bank_name, :status, :created, :updated
    def initialize(
      tax_id:, bank_code: nil, branch_code: nil, key_id: nil, name: nil, number: nil, type: nil, tags: nil,
      id: nil, bank_name: nil, status: nil, created: nil, updated: nil
    )
      super(id)
      @tax_id = tax_id
      @bank_code = bank_code
      @branch_code = branch_code
      @key_id = key_id
      @name = name
      @number = number
      @type = type
      @tags = tags
      @bank_name = bank_name
      @status = status
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create VerifiedAccounts
    #
    # Send a list of VerifiedAccount objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - verified_accounts [list of VerifiedAccount objects]: list of VerifiedAccount objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of VerifiedAccount objects with updated attributes
    def self.create(verified_accounts, user: nil)
      StarkBank::Utils::Rest.post(entities: verified_accounts, user: user, **resource)
    end

    # # Retrieve a specific VerifiedAccount
    #
    # Receive a single VerifiedAccount object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - VerifiedAccount object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Cancel a VerifiedAccount entity
    #
    # Cancel a VerifiedAccount entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: VerifiedAccount unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - canceled VerifiedAccount object
    def self.cancel(id, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    # # Retrieve VerifiedAccounts
    #
    # Receive a generator of VerifiedAccount objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created or updated only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created or updated only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'creating', 'created', 'processing', 'active', 'failed' or 'canceled'
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of VerifiedAccount objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, status: nil, ids: nil, tags: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        status: status,
        ids: ids,
        tags: tags,
        user: user,
        **resource
      )
    end

    # # Retrieve paged VerifiedAccounts
    #
    # Receive a list of up to 100 VerifiedAccount objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created or updated only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created or updated only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'creating', 'created', 'processing', 'active', 'failed' or 'canceled'
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of VerifiedAccount objects with updated attributes and cursor to retrieve the next page of VerifiedAccount objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, status: nil, ids: nil, tags: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        status: status,
        ids: ids,
        tags: tags,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'VerifiedAccount',
        resource_maker: proc { |json|
          VerifiedAccount.new(
            id: json['id'],
            tax_id: json['tax_id'],
            bank_code: json['bank_code'],
            branch_code: json['branch_code'],
            key_id: json['key_id'],
            name: json['name'],
            number: json['number'],
            type: json['type'],
            tags: json['tags'],
            bank_name: json['bank_name'],
            status: json['status'],
            created: json['created'],
            updated: json['updated'],
          )
        }
      }
    end
  end
end
