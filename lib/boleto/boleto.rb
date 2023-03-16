# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')


module StarkBank
  # # Boleto object
  #
  # When you initialize a Boleto, the entity will not be automatically
  # sent to the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - amount [integer]: Boleto value in cents. Minimum = 200 (R$2,00). ex: 1234 (= R$ 12.34)
  # - name [string]: payer full name. ex: 'Anthony Edward Stark'
  # - tax_id [string]: payer tax ID (CPF or CNPJ) with or without formatting. ex: '01234567890' or '20.018.183/0001-80'
  # - street_line_1 [string]: payer main address. ex: Av. Paulista, 200
  # - street_line_2 [string]: payer address complement. ex: Apto. 123
  # - district [string]: payer address district / neighbourhood. ex: Bela Vista
  # - city [string]: payer address city. ex: Rio de Janeiro
  # - state_code [string]: payer address state. ex: GO
  # - zip_code [string]: payer address zip code. ex: 01311-200
  #
  # ## Parameters (optional):
  # - due [Date, DateTime, Time or string, default today + 2 days]: Boleto due date in ISO format. ex: '2020-04-30'
  # - fine [float, default 0.0]: Boleto fine for overdue payment in %. ex: 2.5
  # - interest [float, default 0.0]: Boleto monthly interest for overdue payment in %. ex: 5.2
  # - overdue_limit [integer, default 59]: limit in days for payment after due date. ex: 7 (max: 59)
  # - receiver_name [string]: receiver (Sacador Avalista) full name. ex: 'Anthony Edward Stark'
  # - receiver_tax_id [string]: receiver (Sacador Avalista) tax ID (CPF or CNPJ) with or without formatting. ex: '01234567890' or '20.018.183/0001-80'
  # - descriptions [list of dictionaries, default nil]: list of dictionaries with 'text':string and (optional) 'amount':int pairs
  # - discounts [list of dictionaries, default nil]: list of dictionaries with 'percentage':float and 'date':Date or string pairs
  # - tags [list of strings]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when Boleto is created. ex: '5656565656565656'
  # - fee [integer]: fee charged when Boleto is paid. ex: 200 (= R$ 2.00)
  # - line [string]: generated Boleto line for payment. ex: '34191.09008 63571.277308 71444.640008 5 81960000000062'
  # - bar_code [string]: generated Boleto bar-code for payment. ex: '34195819600000000621090063571277307144464000'
  # - transaction_ids [list of strings]: ledger transaction ids linked to this boleto. ex: ['19827356981273']
  # - workspace_id [string]: ID of the Workspace where this Boleto was generated. ex: "4545454545454545"
  # - status [string]: current Boleto status. ex: 'registered' or 'paid'
  # - created [DateTime]: creation datetime for the Boleto. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - our_number [string]: Reference number registered at the settlement bank. ex:'10131474'
  class Boleto < StarkCore::Utils::Resource
    attr_reader :amount, :name, :tax_id, :street_line_1, :street_line_2, :district, :city, :state_code, :zip_code, :due, :fine, :interest, :overdue_limit, :receiver_name, :receiver_tax_id, :tags, :descriptions, :discounts, :id, :fee, :line, :bar_code, :status, :transaction_ids, :workspace_id, :created, :our_number
    def initialize(
      amount:, name:, tax_id:, street_line_1:, street_line_2:, district:, city:, state_code:, zip_code:,
      due: nil, fine: nil, interest: nil, overdue_limit: nil, receiver_name: nil, receiver_tax_id: nil,
      tags: nil, descriptions: nil, discounts: nil, id: nil, fee: nil, line: nil, bar_code: nil,
      status: nil, transaction_ids: nil, workspace_id: nil, created: nil, our_number: nil
    )
      super(id)
      @amount = amount
      @name = name
      @tax_id = tax_id
      @street_line_1 = street_line_1
      @street_line_2 = street_line_2
      @district = district
      @city = city
      @state_code = state_code
      @zip_code = zip_code
      @due = StarkCore::Utils::Checks.check_date(due)
      @fine = fine
      @interest = interest
      @overdue_limit = overdue_limit
      @receiver_name = receiver_name
      @receiver_tax_id = receiver_tax_id
      @tags = tags
      @descriptions = descriptions
      @discounts = discounts
      @fee = fee
      @line = line
      @bar_code = bar_code
      @status = status
      @transaction_ids = transaction_ids
      @workspace_id = workspace_id
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @our_number = our_number
    end

    # # Create Boletos
    #
    # Send a list of Boleto objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - boletos [list of Boleto objects]: list of Boleto objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of Boleto objects with updated attributes
    def self.create(boletos, user: nil)
      StarkBank::Utils::Rest.post(entities: boletos, user: user, **resource)
    end

    # # Retrieve a specific Boleto
    #
    # Receive a single Boleto object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Boleto object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve a specific Boleto pdf file
    #
    # Receive a single Boleto pdf file generated in the Stark Bank API by passing its id.
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - layout [string]: Layout specification. Available options are 'default' and 'booklet'
    # - hidden_fields [list of strings, default nil]: List of string fields to be hidden in Boleto pdf. ex: ['customerAddress']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Boleto pdf file
    def self.pdf(id, layout: nil, hidden_fields: nil, user: nil)
      StarkBank::Utils::Rest.get_content(id: id, layout: layout, hidden_fields: hidden_fields, sub_resource_name: 'pdf', user: user, **resource)
    end

    # # Retrieve Boletos
    #
    # Receive a generator of Boleto objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'paid' or 'registered'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of Boleto objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    # # Retrieve paged Boletos
    #
    # Receive a list of up to 100 Boleto objects previously created in the Stark Bank API and the cursor to the next page.
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
    # - list of Boleto objects with updated attributes and cursor to retrieve the next page of Boleto objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        user: user,
        **resource
      )
    end

    # # Delete a Boleto entity
    #
    # Delete a Boleto entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: Boleto unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - deleted Boleto object
    def self.delete(id, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'Boleto',
        resource_maker: proc { |json|
          Boleto.new(
            amount: json['amount'],
            name: json['name'],
            tax_id: json['tax_id'],
            street_line_1: json['street_line_1'],
            street_line_2: json['street_line_2'],
            district: json['district'],
            city: json['city'],
            state_code: json['state_code'],
            zip_code: json['zip_code'],
            due: json['due'],
            fine: json['fine'],
            interest: json['interest'],
            overdue_limit: json['overdue_limit'],
            receiver_name: json['receiver_name'],
            receiver_tax_id: json['receiver_tax_id'],
            tags: json['tags'],
            descriptions: json['descriptions'],
            discounts: json['discounts'],
            id: json['id'],
            fee: json['fee'],
            line: json['line'],
            bar_code: json['bar_code'],
            status: json['status'],
            transaction_ids: json['transaction_ids'],
            workspace_id: json['workspace_id'],
            created: json['created'],
            our_number: json['our_number']
          )
        }
      }
    end
  end
end
