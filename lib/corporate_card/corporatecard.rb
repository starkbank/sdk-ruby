# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # CorporateCard object
  #
  # The CorporateCard object displays the information of the cards created in your Workspace.
  # Sensitive information will only be returned when the 'expand' parameter is used, to avoid security concerns.
  #
  # When you initialize a CorporateCard, the entity will not be automatically
  # created in the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the created object.
  #
  # ## Parameters (required):
  # - holder_id [string]: card holder tax ID. ex: '012.345.678-90'
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when CorporateCard is created. ex: '5656565656565656'
  # - holder_name [string, default nil]: card holder name. ex: 'Tony Stark'
  # - display_name [string, default nil]: card displayed name. ex: 'ANTHONY STARK'
  # - rules [list of CorporateRule objects, default nil]: [EXPANDABLE] list of card spending rules.
  # - tags [list of strings, default nil]: list of strings for tagging. ex: ['travel', 'food']
  # - street_line_1 [string, default sub-issuer street line 1]: card holder main address. ex: 'Av. Paulista, 200'
  # - street_line_2 [string, default sub-issuer street line 2]: card holder address complement. ex: 'Apto. 123'
  # - district [string, default sub-issuer district]: card holder address district / neighbourhood. ex: 'Bela Vista'
  # - city [string, default sub-issuer city]: card holder address city. ex: 'Rio de Janeiro'
  # - state_code [string, default sub-issuer state code]: card holder address state. ex: 'GO'
  # - zip_code [string, default sub-issuer zip code]: card holder address zip code. ex: '01311-200'
  # - type [string]: card type. ex: 'virtual'
  # - status [string]: current CorporateCard status. ex: 'active', 'blocked', 'canceled', 'expired'.
  # - number [string]: [EXPANDABLE] masked card number. Expand to unmask the value. ex: '123'.
  # - security_code [string]: [EXPANDABLE] masked card verification value (cvv). Expand to unmask the value. ex: '123'.
  # - expiration [DateTime]: [EXPANDABLE] masked card expiration datetime. Expand to unmask the value. ex: DateTime.new(2032, 3, 10, 10, 30, 0, 0)
  # - created [DateTime]: creation datetime for the CorporateCard. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: latest update datetime for the CorporateCard. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class CorporateCard < StarkCore::Utils::Resource
    attr_reader :holder_id, :id, :holder_name, :display_name, :rules, :tags,
                :street_line_1, :street_line_2, :district, :city, :state_code, :zip_code,
                :type, :status, :number, :security_code, :expiration, :created, :updated
    def initialize(
      holder_id:, holder_name: nil, display_name: nil, rules: nil, tags: nil,
      street_line_1: nil, street_line_2: nil, district: nil, city: nil, state_code: nil, zip_code: nil, id: nil,
      type: nil, status: nil, number: nil, security_code: nil, expiration: nil, created: nil, updated: nil
    )
      super(id)
      @holder_id = holder_id
      @holder_name = holder_name
      @display_name = display_name
      @rules = StarkBank::CorporateRule.parse_rules(rules)
      @tags = tags
      @street_line_1 = street_line_1
      @street_line_2 = street_line_2
      @district = district
      @city = city
      @state_code = state_code
      @zip_code = zip_code
      @type = type
      @status = status
      @number = number
      @security_code = security_code
      expiration = nil if !expiration.nil? && expiration.include?('*')
      @expiration = StarkCore::Utils::Checks.check_datetime(expiration)
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create CorporateCards
    #
    # Send a CorporateCard object for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - card [CorporateCard object]: CorporateCard object to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - CorporateCard object with updated attributes
    def self.create(card:, expand: nil, user: nil)
      path =  StarkCore::Utils::API.endpoint(resource[:resource_name]) + '/token'
      payload = StarkCore::Utils::API.api_json(card)
      json = StarkBank::Utils::Rest.post_raw(path: path, payload: payload, expand: expand, user: user)
      entity_json = json[StarkCore::Utils::API.last_name(resource[:resource_name])]
      StarkCore::Utils::API.from_api_json(resource[:resource_maker], entity_json)
    end

    # # Retrieve a specific CorporateCard
    #
    # Receive a single CorporateCard object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - expand [list of strings, default nil]: fields to expand information. ex: ['rules', 'securityCode', 'number', 'expiration']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - CorporateCard object with updated attributes
    def self.get(id, expand: nil, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, expand: expand, user: user, **resource)
    end

    # # Retrieve CorporateCards
    #
    # Receive a generator of CorporateCard objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [list of strings, default nil]: filter for status of retrieved objects. ex: ['active', 'blocked', 'canceled', 'expired']
    # - types [list of strings, default nil]: card type. ex: ['virtual']
    # - holder_ids [list of strings, default nil]: card holder IDs. ex: ['5656565656565656', '4545454545454545']
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - expand [list of strings, default nil]: fields to expand information. ex: ['rules', 'security_code', 'number', 'expiration']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of CorporateCards objects with updated attributes
    def self.query(limit: nil, ids: nil, after: nil, before: nil, status: nil, types: nil, holder_ids: nil, tags: nil,
                   expand: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        ids: ids,
        after: after,
        before: before,
        status: status,
        types: types,
        holder_ids: holder_ids,
        tags: tags,
        expand: expand,
        user: user,
        **resource
      )
    end

    # # Retrieve paged CorporateCards
    #
    # Receive a list of up to 100 CorporateCard objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your identities.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call.
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [list of strings, default nil]: filter for status of retrieved objects. ex: ['active', 'blocked', 'canceled', 'expired']
    # - types [list of strings, default nil]: card type. ex: ['virtual']
    # - holder_ids [list of strings, default nil]: card holder IDs. ex: ['5656565656565656', '4545454545454545']
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - expand [list of strings, default nil]: fields to expand information. ex: ['rules', 'security_code', 'number', 'expiration']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of CorporateCard objects with updated attributes
    # - cursor to retrieve the next page of CorporateCards objects
    def self.page(cursor: nil, limit: nil, ids: nil, after: nil, before: nil, status: nil, types: nil, holder_ids: nil,
                  tags: nil, expand: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        ids: ids,
        after: after,
        before: before,
        status: status,
        types: types,
        holder_ids: holder_ids,
        tags: tags,
        expand: expand,
        user: user,
        **resource
      )
    end

    # # Update CorporateCard entity
    #
    # Update a CorporateCard by passing id.
    #
    # ## Parameters (required):
    # - id [string]: CorporateCard unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - status [string, default nil]: You may block the CorporateCard by passing 'blocked' or activate by passing 'active' in the status
    # - pin [string, default nil]: You may unlock your physical card by passing its PIN. This is also the PIN you use to authorize a purchase.
    # - display_name [string, default nil]: card displayed name. ex: "ANTHONY EDWARD"
    # - rules [list of CorporateRule objects, default nil]: [EXPANDABLE] list of card spending rules.
    # - tags [list of strings, default nil]: list of strings for tagging
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - target CorporateCard with updated attributes
    def self.update(id, status: nil, display_name: nil,pin: nil, rules: nil, tags: nil, user: nil)
      StarkBank::Utils::Rest.patch_id(
        id: id,
        status: status,
        pin: pin,
        display_name: display_name,
        rules: rules,
        tags: tags,
        user: user,
        **resource
      )
    end

    # # Cancel a CorporateCard entity
    #
    # Cancel a CorporateCard entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: CorporateCard unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - canceled CorporateCard object
    def self.cancel(id, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'CorporateCard',
        resource_maker: proc { |json|
          CorporateCard.new(
            holder_id: json['holder_id'],
            id: json['id'],
            holder_name: json['holder_name'],
            display_name: json['display_name'],
            rules: json['rules'],
            tags: json['tags'],
            street_line_1: json['street_line_1'],
            street_line_2: json['street_line_2'],
            district: json['district'],
            city: json['city'],
            state_code: json['state_code'],
            zip_code: json['zip_code'],
            type: json['type'],
            status: json['status'],
            number: json['number'],
            security_code: json['security_code'],
            expiration: json['expiration'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
