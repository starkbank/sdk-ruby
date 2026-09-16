# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # SplitReceiver object
  #
  # When you initialize a SplitReceiver, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - name [string]: receiver full name. ex: 'Anthony Edward Stark'
  # - tax_id [string]: receiver account tax ID (CPF or CNPJ) with or without formatting. ex: '01234567890' or '20.018.183/0001-80'
  # - bank_code [string]: code of the receiver bank institution in Brazil. If an ISPB (8 digits) is informed, a PIX splitReceiver will be created, else a TED will be issued. ex: '20018183' or '341'
  # - branch_code [string]: receiver bank account branch. Use '-' in case there is a verifier digit. ex: '1357-9'
  # - account_number [string]: receiver bank account number. Use '-' before the verifier digit. ex: '876543-2'
  # - account_type [string]: receiver bank account type. This parameter only has effect on Pix SplitReceivers. ex: 'checking', 'savings', 'salary' or 'payment'
  #
  # ## Parameters (optional):
  # - tags [list of strings, default nil]: list of strings for reference when searching for receivers. ex: ['seller/123456']
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when the splitReceiver is created. ex: '5656565656565656'
  # - status [string]: current splitReceiver status. ex: 'success' or 'failed'
  # - created [DateTime]: creation datetime for the splitReceiver. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: latest update datetime for the splitReceiver. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class SplitReceiver < StarkCore::Utils::Resource
    attr_reader :name, :tax_id, :bank_code, :branch_code, :account_number, :account_type, :tags, :id, :status,
                :created, :updated
    def initialize(
      name:, tax_id:, bank_code:, branch_code:, account_number:, account_type:, tags: nil, id: nil, status: nil,
      created: nil, updated: nil
    )
      super(id)
      @name = name
      @tax_id = tax_id
      @bank_code = bank_code
      @branch_code = branch_code
      @account_number = account_number
      @account_type = account_type
      @tags = tags
      @status = status
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create SplitReceivers
    #
    # Send a list of SplitReceiver objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - receivers [list of SplitReceiver objects]: list of SplitReceiver objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of SplitReceiver objects with updated attributes
    def self.create(receivers, user: nil)
      StarkBank::Utils::Rest.post(entities: receivers, user: user, **resource)
    end

    # # Retrieve a specific SplitReceiver
    #
    # Receive a single SplitReceiver object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - SplitReceiver object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve SplitReceivers
    #
    # Receive a generator of SplitReceiver objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created or updated only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created or updated only before specified date. ex: Date.new(2020, 3, 10)
    # - transaction_ids [list of strings, default nil]: list of transaction IDs linked to the desired splitReceivers. ex: ['5656565656565656', '4545454545454545']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'success' or 'failed'
    # - tax_id [string, default nil]: filter for splitReceivers sent to the specified tax ID. ex: '012.345.678-90'
    # - sort [string, default '-created']: sort order considered in response. Valid options are 'created', '-created', 'updated' or '-updated'.
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of SplitReceiver objects with updated attributes
    def self.query(
      limit: nil, after: nil, before: nil, transaction_ids: nil, status: nil, tax_id: nil, sort: nil, tags: nil,
      ids: nil, user: nil
    )
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

    # # Retrieve paged SplitReceivers
    #
    # Receive a list of up to 100 SplitReceiver objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 50
    # - after [Date or string, default nil]: date filter for objects created or updated only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created or updated only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'success' or 'failed'
    # - sort [string, default '-created']: sort order considered in response. Valid options are 'created', '-created', 'updated' or '-updated'.
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of SplitReceiver objects with updated attributes
    # - cursor to retrieve the next page of SplitReceiver objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, status: nil, sort: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
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
        resource_name: 'SplitReceiver',
        resource_maker: proc { |json|
          SplitReceiver.new(
            id: json['id'],
            name: json['name'],
            tax_id: json['tax_id'],
            bank_code: json['bank_code'],
            branch_code: json['branch_code'],
            account_number: json['account_number'],
            account_type: json['account_type'],
            tags: json['tags'],
            status: json['status'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
