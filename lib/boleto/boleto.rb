# frozen_string_literal: true

require_relative('../utils/resource')
require_relative('../utils/rest')
require_relative('../utils/checks')

module StarkBank
  # # Boleto object
  #
  # When you initialize a Boleto, the entity will not be automatically
  # sent to the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # ## Parameters (required):
  # - amount [integer]: Boleto value in cents. Minimum = 200 (R$2,00). ex: 1234 (= R$ 12.34)
  # - name [string]: payer full name. ex: "Anthony Edward Stark"
  # - tax_id [string]: payer tax ID (CPF or CNPJ) with or without formatting. ex: "01234567890" or "20.018.183/0001-80"
  # - street_line_1 [string]: payer main address. ex: Av. Paulista, 200
  # - street_line_2 [string]: payer address complement. ex: Apto. 123
  # - district [string]: payer address district / neighbourhood. ex: Bela Vista
  # - city [string]: payer address city. ex: Rio de Janeiro
  # - state_code [string]: payer address state. ex: GO
  # - zip_code [string]: payer address zip code. ex: 01311-200
  # - due [datetime.date, default today + 2 days]: Boleto due date in ISO format. ex: 2020-04-30
  #
  # ## Parameters (optional):
  # - fine [float, default 0.0]: Boleto fine for overdue payment in %. ex: 2.5
  # - interest [float, default 0.0]: Boleto monthly interest for overdue payment in %. ex: 5.2
  # - overdue_limit [integer, default 59]: limit in days for automatic Boleto cancellation after due date. ex: 7 (max: 59)
  # - descriptions [list of dictionaries, default None]: list of dictionaries with "text":string and (optional) "amount":int pairs
  # - tags [list of strings]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - id [string, default None]: unique id returned when Boleto is created. ex: "5656565656565656"
  # - fee [integer, default None]: fee charged when Boleto is paid. ex: 200 (= R$ 2.00)
  # - line [string, default None]: generated Boleto line for payment. ex: "34191.09008 63571.277308 71444.640008 5 81960000000062"
  # - bar_code [string, default None]: generated Boleto bar-code for payment. ex: "34195819600000000621090063571277307144464000"
  # - status [string, default None]: current Boleto status. ex: "registered" or "paid"
  # - created [datetime.datetime, default None]: creation datetime for the Boleto. ex: datetime.datetime(2020, 3, 10, 10, 30, 0, 0)
  class Boleto < StarkBank::Utils::Resource
    attr_reader :amount, :name, :tax_id, :street_line_1, :street_line_2, :district, :city, :state_code, :zip_code, :due, :fine, :interest, :overdue_limit, :tags, :descriptions, :id, :fee, :line, :bar_code, :status, :created
    def initialize(
      amount:, name:, tax_id:, street_line_1:, street_line_2:, district:, city:, state_code:, zip_code:,
      due: nil, fine: nil, interest: nil, overdue_limit: nil, tags: nil, descriptions: nil, id: nil, fee: nil, line: nil,
      bar_code: nil, status: nil, created: nil
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
      @due = due
      @fine = fine
      @interest = interest
      @overdue_limit = overdue_limit
      @tags = tags
      @descriptions = descriptions
      @fee = fee
      @line = line
      @bar_code = bar_code
      @status = status
      @created = StarkBank::Utils::Checks.check_datetime(created)
    end

    # # Create Boletos
    #
    # Send a list of Boleto objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - boletos [list of Boleto objects]: list of Boleto objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of Boleto objects with updated attributes
    def self.create(boletos:, user: nil)
      StarkBank::Utils::Rest.post(entities: boletos, user: user, **resource)
    end

    # # Retrieve a specific Boleto
    #
    # Receive a single Boleto object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: "5656565656565656"
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - Boleto object with updated attributes
    def self.get(id:, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve a specific Boleto pdf file
    #
    # Receive a single Boleto pdf file generated in the Stark Bank API by passing its id.
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: "5656565656565656"
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - Boleto pdf file
    def self.pdf(id:, user: nil)
      StarkBank::Utils::Rest.get_pdf(id: id, user: user, **resource)
    end

    # # Retrieve Boletos
    #
    # Receive a generator of Boleto objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default None]: maximum number of objects to be retrieved. Unlimited if None. ex: 35
    # - status [string, default None]: filter for status of retrieved objects. ex: "paid" or "registered"
    # - tags [list of strings, default None]: tags to filter retrieved objects. ex: ["tony", "stark"]
    # - ids [list of strings, default None]: list of ids to filter retrieved objects. ex: ["5656565656565656", "4545454545454545"]
    # - after [datetime.date, default None] date filter for objects created only after specified date. ex: datetime.date(2020, 3, 10)
    # - before [datetime.date, default None] date filter for objects only before specified date. ex: datetime.date(2020, 3, 10)
    # - user [Project object, default None]: Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of Boleto objects with updated attributes
    def self.query(limit: nil, status: nil, tags: nil, ids: nil, after: nil, before: nil, user: nil)
      after = StarkBank::Utils::Checks.check_date(after)
      before = StarkBank::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_list(user: user, limit: limit, status: status, tags: tags, ids: ids, after: after, before: before, **resource)
    end

    # # Delete a Boleto entity
    #
    # Delete a Boleto entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: Boleto unique id. ex: "5656565656565656"
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if starkbank.user was set before function call
    # ## Return:
    # - deleted Boleto with updated attributes
    def self.delete(id:, user: nil)
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
            tags: json['tags'],
            descriptions: json['descriptions'],
            id: json['id'],
            fee: json['fee'],
            line: json['line'],
            bar_code: json['bar_code'],
            status: json['status'],
            created: json['created']
          )
        }
      }
    end
  end
end
