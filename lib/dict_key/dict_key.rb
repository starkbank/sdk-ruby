# frozen_string_literal: true

require_relative('../utils/rest.rb')


module StarkBank
  # # DictKey object
  #
  # DictKey represents a Pix key registered in Bacen's DICT system.
  #
  # ## Parameters (optional):
  # - id [string]: DictKey object unique id and Pix key itself. ex: 'tony@starkbank.com', '722.461.430-04', '20.018.183/0001-80', '+5511988887777', 'b6295ee1-f054-47d1-9e90-ee57b74f60d9'
  #
  # ## Attributes (return-only):
  # - type [string]: DICT key type. ex: 'email', 'cpf', 'cnpj', 'phone' or 'evp'
  # - name [string]: account owner full name. ex: 'Tony Stark'
  # - tax_id [string]: key owner tax ID (CNPJ or masked CPF). ex: '***.345.678-**' or '20.018.183/0001-80'
  # - owner_type [string]: DICT key owner type. ex 'naturalPerson' or 'legalPerson'
  # - bank_name [string]: bank name associated with the DICT key. ex: 'Stark Bank'
  # - ispb [string]: bank ISPB associated with the DICT key. ex: '20018183'
  # - branch_code [string]: bank account branch code associated with the DICT key. ex: '9585'
  # - account_number [string]: bank account number associated with the DICT key. ex: '9828282578010513'
  # - account_type [string]: bank account type associated with the DICT key. ex: 'checking', 'saving', 'salary' or 'payment'
  # - status [string]: current DICT key status. ex: 'created', 'registered', 'canceled' or 'failed'
  class DictKey < StarkCore::Utils::Resource
    attr_reader :id, :type, :name, :tax_id, :owner_type, :bank_name, :ispb, :branch_code, :account_number, :account_type, :status, :account_created, :owned, :created
    def initialize(
      id:, type:, name:, tax_id:, owner_type:, bank_name:, ispb:, 
      branch_code:, account_number:, account_type:, status:
    )
      super(id)
      @type = type
      @name = name
      @tax_id = tax_id
      @owner_type = owner_type
      @bank_name = bank_name
      @ispb = ispb
      @branch_code = branch_code
      @account_number = account_number
      @account_type = account_type
      @status = status
    end

    # # Retrieve a specific DictKey
    #
    # Receive a single DictKey object by passing its id
    #
    # ## Parameters (required):
    # - id [string]: DictKey object unique id and Pix key itself. ex: 'tony@starkbank.com', '722.461.430-04', '20.018.183/0001-80', '+5511988887777', 'b6295ee1-f054-47d1-9e90-ee57b74f60d9'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - DictKey object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve DitcKeys
    #
    # Receive a generator of DitcKey objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - type [string, default nil]: DictKey type. ex: 'cpf', 'cnpj', 'phone', 'email' or 'evp'
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'canceled', 'registered'
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of DitcKey objects with updated attributes
    def self.query(limit: nil, type: nil, after: nil, before: nil, ids: nil, status: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        type: type,
        after: after,
        before: before,
        ids: ids,
        status: status,
        user: user,
        **resource
      )
    end

    # # Retrieve paged DictKeys
    #
    # Receive a list of up to 100 DictKey objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - type [string, default nil]: DictKey type. ex: 'cpf', 'cnpj', 'phone', 'email' or 'evp'
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'canceled', 'registered'
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of DictKey objects with updated attributes and cursor to retrieve the next page of DictKey objects
    def self.page(cursor: nil, limit: nil, type: nil, after: nil, before: nil, ids: nil, status: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        type: type,
        after: after,
        before: before,
        ids: ids,
        status: status,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'DictKey',
        resource_maker: proc { |json|
          DictKey.new(
            id: json['id'],
            account_type: json['account_type'],
            name: json['name'],
            tax_id: json['tax_id'],
            owner_type: json['owner_type'],
            bank_name: json['bank_name'],
            ispb: json['ispb'],
            branch_code: json['branch_code'],
            account_number: json['account_number'],
            type: json['type'],
            status: json['status']
          )
        }
      }
    end
  end
end
