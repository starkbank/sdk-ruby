# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')


module StarkBank
  # # DynamicBrcode object
  # 
  # When you initialize a DynamicBrcode, the entity will not be automatically
  # sent to the Stark Bank API. The 'create' function sends the objects
  # to the Stark Bank API and returns the list of created objects.
  #
  # DynamicBrcodes are conciliated BR Codes that can be used to receive Pix transactions in a convenient way.
  # When a DynamicBrcode is paid, a Deposit is created with the tags parameter containing the character “dynamic-brcode/” followed by the DynamicBrcode’s uuid "dynamic-brcode/{uuid}" for conciliation.
  # Additionally, all tags passed on the DynamicBrcode will be transferred to the respective Deposit resource.
  #
  # ## Parameters (required):
  # - amount [integer]: DynamicBrcode value in cents. Minimum = 0 (any value will be accepted). ex: 1234 (= R$ 12.34)
  #
  # ## Parameters (optional):
  # - expiration [integer, default 3600 (1 hour)]: time interval in seconds between due date and expiration date. ex 123456789
  # - tags [list of strings, default []]: list of strings for tagging, these will be passed to the respective DynamicBrcode resource when paid
  #
  # ## Attributes (return-only):
  # - id [string]: id returned on creation, this is the BR code. ex: "00020126360014br.gov.bcb.pix0114+552840092118152040000530398654040.095802BR5915Jamie Lannister6009Sao Paulo620705038566304FC6C"
  # - uuid [string]: unique uuid returned when the DynamicBrcode is created. ex: "4e2eab725ddd495f9c98ffd97440702d"
  # - picture_url [string]: public QR Code (png image) URL. "https://sandbox.api.starkbank.com/v2/dynamic-brcode/d3ebb1bd92024df1ab6e5a353ee799a4.png"
  # - updated [DateTime]: latest update datetime for the DynamicBrcode. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - created [DateTime]: creation datetime for the DynamicBrcode. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class DynamicBrcode < StarkCore::Utils::Resource
    attr_reader :amount, :expiration, :tags, :id, :uuid, :picture_url, :updated, :created
    def initialize(
      amount:, expiration: nil, tags: nil, id: nil, uuid: nil, picture_url: nil, updated: nil, created: nil
    )
      super(id)
      @amount = amount
      @expiration = expiration
      @tags = tags
      @uuid = uuid
      @picture_url = picture_url
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create DynamicBrcode
    #
    # Send a list of DynamicBrcode objects for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - brcodes [list of DynamicBrcode objects]: list of DynamicBrcode objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of DynamicBrcode objects with updated attributes
    def self.create(brcodes, user: nil)
      StarkBank::Utils::Rest.post(entities: brcodes, user: user, **resource)
    end

    # # Retrieve a specific DynamicBrcode
    #
    # Receive a single DynamicBrcode object previously created in the Stark Bank API by its uuid
    #
    # ## Parameters (required):
    # - uuid [string]: object unique uuid. ex: "901e71f2447c43c886f58366a5432c4b"
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - DynamicBrcode object with updated attributes
    def self.get(uuid, user: nil)
      StarkBank::Utils::Rest.get_id(id: uuid, user: user, **resource)
    end

    # # Retrieve DynamicBrcodes
    #
    # Receive a generator of DynamicBrcode objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - uuids [list of strings, default nil]: list of uuids to filter retrieved objects. ex: ["901e71f2447c43c886f58366a5432c4b", "4e2eab725ddd495f9c98ffd97440702d"]
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of DynamicBrcode objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, tags: nil, uuids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        tags: tags,
        uuids: uuids,
        user: user,
        **resource
      )
    end

    # # Retrieve paged DynamicBrcodes
    #
    # Receive a list of up to 100 DynamicBrcode objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - uuids [list of strings, default nil]: list of uuids to filter retrieved objects. ex: ["901e71f2447c43c886f58366a5432c4b", "4e2eab725ddd495f9c98ffd97440702d"]
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of DynamicBrcode objects with updated attributes and cursor to retrieve the next page of DynamicBrcode objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, tags: nil, uuids: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        tags: tags,
        uuids: uuids,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'DynamicBrcode',
        resource_maker: proc { |json|
          DynamicBrcode.new(
            id: json['id'],
            amount: json['amount'],
            expiration: json['expiration'],
            tags: json['tags'],
            uuid: json['uuid'],
            picture_url: json['picture_url'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
