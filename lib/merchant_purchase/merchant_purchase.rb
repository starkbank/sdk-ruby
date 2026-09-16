# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # MerchantPurchase object
  #
  # When you initialize a MerchantPurchase, the entity will not be automatically
  # sent to the Stark Bank API. The 'create' function sends the object
  # to the Stark Bank API and returns the created object.
  #
  # ## Parameters (required):
  # - amount [integer]: MerchantPurchase value in cents. ex: 1234 (= R$ 12.34)
  # - card_id [string]: unique id of the MerchantCard or MerchantSession Purchase used. ex: '5656565656565656'
  # - funding_type [string]: type of funding used. ex: 'credit', 'debit'
  # - installment_count [integer]: number of installments the purchase is split into. ex: 1
  #
  # ## Parameters (optional):
  # - card_expiration [string, default nil]: card and holder data, required only when not created through a MerchantSession.
  # - card_number [string, default nil]: card and holder data, required only when not created through a MerchantSession.
  # - card_security_code [string, default nil]: card and holder data, required only when not created through a MerchantSession.
  # - holder_name [string, default nil]: card and holder data, required only when not created through a MerchantSession.
  # - holder_email [string, default nil]: card and holder data, required only when not created through a MerchantSession.
  # - holder_phone [string, default nil]: card and holder data, required only when not created through a MerchantSession.
  # - holder_id [string, default nil]: card and holder data, required only when not created through a MerchantSession.
  # - billing_country_code [string, default nil]: billing address data.
  # - billing_city [string, default nil]: billing address data.
  # - billing_state_code [string, default nil]: billing address data.
  # - billing_street_line_1 [string, default nil]: billing address data.
  # - billing_street_line_2 [string, default nil]: billing address data.
  # - billing_zip_code [string, default nil]: billing address data.
  # - metadata [dictionary, default nil]: additional 3DS metadata sent by the merchant's browser/app.
  # - soft_descriptor [string, default nil]: text that will be shown in the holder's bank statement. ex: 'my-store'
  # - tags [list of strings, default nil]: list of strings for tagging
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when MerchantPurchase is created. ex: '5656565656565656'
  # - card_ending [string]: last 4 digits of the card used. ex: '1234'
  # - challenge_mode [string]: whether 3DS holder verification was used. ex: 'enabled', 'disabled'
  # - challenge_url [string]: URL to the 3DS challenge, when applicable.
  # - currency_code [string]: currency of the purchase. ex: 'BRL'
  # - end_to_end_id [string]: unique transaction id for the acquirer network.
  # - fee [integer]: fee charged when the MerchantPurchase is processed. ex: 200 (= R$ 2.00)
  # - network [string]: card network flag. ex: 'visa', 'mastercard'
  # - source [string]: locator of the entity that generated the purchase. ex: 'merchant-session/{sessionId}'
  # - status [string]: current MerchantPurchase status. ex: 'approved', 'confirmed', 'canceled', 'voided'
  # - created [DateTime]: creation datetime for the MerchantPurchase. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  # - updated [DateTime]: latest update datetime for the MerchantPurchase. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
  class MerchantPurchase < StarkCore::Utils::Resource
    attr_reader :id, :amount, :card_id, :funding_type, :installment_count, :card_expiration, :card_number,
                :card_security_code, :holder_name, :holder_email, :holder_phone, :holder_id, :billing_country_code,
                :billing_city, :billing_state_code, :billing_street_line_1, :billing_street_line_2, :billing_zip_code,
                :metadata, :soft_descriptor, :tags, :card_ending, :challenge_mode, :challenge_url, :currency_code,
                :end_to_end_id, :fee, :network, :source, :status, :created, :updated
    def initialize(
      amount:, card_id:, funding_type:, installment_count:, id: nil, card_expiration: nil, card_number: nil,
      card_security_code: nil, holder_name: nil, holder_email: nil, holder_phone: nil, holder_id: nil,
      billing_country_code: nil, billing_city: nil, billing_state_code: nil, billing_street_line_1: nil,
      billing_street_line_2: nil, billing_zip_code: nil, metadata: nil, soft_descriptor: nil, tags: nil,
      card_ending: nil, challenge_mode: nil, challenge_url: nil, currency_code: nil, end_to_end_id: nil, fee: nil,
      network: nil, source: nil, status: nil, created: nil, updated: nil
    )
      super(id)
      @amount = amount
      @card_id = card_id
      @funding_type = funding_type
      @installment_count = installment_count
      @card_expiration = card_expiration
      @card_number = card_number
      @card_security_code = card_security_code
      @holder_name = holder_name
      @holder_email = holder_email
      @holder_phone = holder_phone
      @holder_id = holder_id
      @billing_country_code = billing_country_code
      @billing_city = billing_city
      @billing_state_code = billing_state_code
      @billing_street_line_1 = billing_street_line_1
      @billing_street_line_2 = billing_street_line_2
      @billing_zip_code = billing_zip_code
      @metadata = metadata
      @soft_descriptor = soft_descriptor
      @tags = tags
      @card_ending = card_ending
      @challenge_mode = challenge_mode
      @challenge_url = challenge_url
      @currency_code = currency_code
      @end_to_end_id = end_to_end_id
      @fee = fee
      @network = network
      @source = source
      @status = status
      @created = StarkCore::Utils::Checks.check_datetime(created)
      @updated = StarkCore::Utils::Checks.check_datetime(updated)
    end

    # # Create a MerchantPurchase
    #
    # Send a MerchantPurchase object for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - purchase [MerchantPurchase object]: MerchantPurchase object to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - MerchantPurchase object with updated attributes
    def self.create(purchase, user: nil)
      StarkBank::Utils::Rest.post_single(entity: purchase, user: user, **resource)
    end

    # # Retrieve a specific MerchantPurchase
    #
    # Receive a single MerchantPurchase object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - MerchantPurchase object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve MerchantPurchases
    #
    # Receive a generator of MerchantPurchase objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'approved'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - holder_id [string, default nil]: filter for purchases made with cards belonging to a specific holder. ex: '5656565656565656'
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of MerchantPurchase objects with updated attributes
    def self.query(limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, holder_id: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        holder_id: holder_id,
        user: user,
        **resource
      )
    end

    # # Retrieve paged MerchantPurchases
    #
    # Receive a list of up to 100 MerchantPurchase objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - status [string, default nil]: filter for status of retrieved objects. ex: 'approved'
    # - tags [list of strings, default nil]: tags to filter retrieved objects. ex: ['tony', 'stark']
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - holder_id [string, default nil]: filter for purchases made with cards belonging to a specific holder. ex: '5656565656565656'
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of MerchantPurchase objects with updated attributes
    # - cursor to retrieve the next page of MerchantPurchase objects
    def self.page(cursor: nil, limit: nil, after: nil, before: nil, status: nil, tags: nil, ids: nil, holder_id: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit,
        after: after,
        before: before,
        status: status,
        tags: tags,
        ids: ids,
        holder_id: holder_id,
        user: user,
        **resource
      )
    end

    # # Update MerchantPurchase entity
    #
    # Update a MerchantPurchase by its id. If the purchase is 'approved', you may only cancel it by passing
    # status: 'canceled' together with amount: 0. If the purchase is 'confirmed', you may pass status: 'reversed'
    # with a lower amount to debit and reverse the difference, partially or totally; a partial reversal keeps
    # status 'confirmed', while a full reversal moves it to 'voided'.
    #
    # ## Parameters (required):
    # - id [string]: MerchantPurchase id.
    #
    # ## Parameters (optional):
    # - status [string, default nil]: 'canceled' or 'reversed', per the rules above.
    # - amount [integer, default nil]: new amount; 0 to cancel an approved purchase, or a lower value to partially/fully reverse a confirmed one.
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - target MerchantPurchase with updated attributes
    def self.update(id, status: nil, amount: nil, user: nil)
      StarkBank::Utils::Rest.patch_id(id: id, status: status, amount: amount, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'MerchantPurchase',
        resource_maker: proc { |json|
          MerchantPurchase.new(
            id: json['id'],
            amount: json['amount'],
            card_id: json['card_id'],
            funding_type: json['funding_type'],
            installment_count: json['installment_count'],
            card_expiration: json['card_expiration'],
            card_number: json['card_number'],
            card_security_code: json['card_security_code'],
            holder_name: json['holder_name'],
            holder_email: json['holder_email'],
            holder_phone: json['holder_phone'],
            holder_id: json['holder_id'],
            billing_country_code: json['billing_country_code'],
            billing_city: json['billing_city'],
            billing_state_code: json['billing_state_code'],
            billing_street_line_1: json['billing_street_line_1'],
            billing_street_line_2: json['billing_street_line_2'],
            billing_zip_code: json['billing_zip_code'],
            metadata: json['metadata'],
            soft_descriptor: json['soft_descriptor'],
            tags: json['tags'],
            card_ending: json['card_ending'],
            challenge_mode: json['challenge_mode'],
            challenge_url: json['challenge_url'],
            currency_code: json['currency_code'],
            end_to_end_id: json['end_to_end_id'],
            fee: json['fee'],
            network: json['network'],
            source: json['source'],
            status: json['status'],
            created: json['created'],
            updated: json['updated']
          )
        }
      }
    end
  end
end
