# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # CorporatePurchase object
  #
  # Displays the CorporatePurchase objects created in your Workspace.
  #
  # ## Attributes (return-only):
  # - id [string]: unique id returned when CorporatePurchase is created. ex: "5656565656565656"
  # - holder_id [string]: card holder unique id. ex: "5656565656565656"
  # - holder_name [string]: card holder name. ex: "Tony Stark"
  # - center_id [string]: target cost center ID. ex: "5656565656565656"
  # - card_id [string]: unique id returned when CorporateCard is created. ex: "5656565656565656"
  # - card_ending [string]: last 4 digits of the card number. ex: "1234"
  # - description [string]: purchase descriptions. ex: "my_description"
  # - amount [integer]: CorporatePurchase value in cents. Minimum = 0. ex: 1234 (= R$ 12.34)
  # - tax [integer]: IOF amount taxed for international purchases. ex: 1234 (= R$ 12.34)
  # - corporate_amount [integer]: corporate amount. ex: 1234 (= R$ 12.34)
  # - corporate_currency_code [string]: corporate currency code. ex: "USD"
  # - corporate_currency_symbol [string]: corporate currency symbol. ex: "$"
  # - merchant_amount [integer]: merchant amount. ex: 1234 (= R$ 12.34)
  # - merchant_currency_code [string]: merchant currency code. ex: "USD"
  # - merchant_currency_symbol [string]: merchant currency symbol. ex: "$"
  # - merchant_category_code [string]: merchant category code. ex: "fastFoodRestaurants"
  # - merchant_category_type [string]: merchant category type. ex: "health"
  # - merchant_country_code [string]: merchant country code. ex: "USA"
  # - merchant_name [string]: merchant name. ex: "Google Cloud Platform"
  # - merchant_display_name [string]: merchant name. ex: "Google Cloud Platform"
  # - merchant_display_url [string]: public merchant icon (png image). ex: "https://sandbox.api.starkbank.com/v2/corporate-icon/merchant/ifood.png"
  # - merchant_fee [integer]: fee charged by the merchant to cover specific costs, such as ATM withdrawal logistics, etc. ex: 200 (= R$ 2.00)
  # - method_code [string]: method code. Options: "chip", "token", "server", "manual", "magstripe" or "contactless"
  # - tags [list of strings]: list of strings for tagging returned by the sub-issuer during the authorization. ex: ["travel", "food"]
  # - corporate_transaction_ids [list of strings]: ledger transaction ids linked to this Purchase
  # - status [string]: current CorporateCard status. Options: "approved", "canceled", "denied", "confirmed", "voided"
  # - updated [DateTime]: latest update datetime for the CorporatePurchase. ex: DateTime(2020, 3, 10, 10, 30, 0, 0)
  # - created [DateTime]: creation datetime for the CorporatePurchase. ex: DateTime(2020, 3, 10, 10, 30, 0, 0)
  class CorporatePurchase < StarkCore::Utils::Resource
    attr_reader :id, :holder_id, :holder_name, :center_id, :card_id, :card_ending, :description, :amount, :tax, :corporate_amount,
                :corporate_currency_code, :corporate_currency_symbol, :merchant_amount, :merchant_currency_code, :merchant_currency_symbol,
                :merchant_category_code, :merchant_category_type, :merchant_country_code, :merchant_name, :merchant_display_name,
                :merchant_display_url, :merchant_fee, :method_code, :tags, :corporate_transaction_ids, :status, :updated, :created
    def initialize(
      id: nil, holder_id: nil, holder_name: nil, center_id: nil, card_id: nil, card_ending: nil, description: nil, amount: nil, tax: nil, corporate_amount: nil,
      corporate_currency_code: nil, corporate_currency_symbol: nil, merchant_amount: nil, merchant_currency_code: nil, merchant_currency_symbol: nil,
      merchant_category_code: nil, merchant_category_type: nil, merchant_country_code: nil, merchant_name: nil, merchant_display_name: nil,
      merchant_display_url: nil, merchant_fee: nil, method_code: nil, tags: nil, corporate_transaction_ids: nil, status: nil, updated: nil, created: nil
    )
      super(id)
      @holder_id = holder_id
      @holder_name = holder_name
      @center_id = center_id
      @card_id = card_id
      @card_ending = card_ending
      @description = description
      @amount = amount
      @tax = tax
      @corporate_amount = corporate_amount
      @corporate_currency_code = corporate_currency_code
      @corporate_currency_symbol = corporate_currency_symbol
      @merchant_amount = merchant_amount
      @merchant_currency_code = merchant_currency_code
      @merchant_currency_symbol = merchant_currency_symbol
      @merchant_category_code = merchant_category_code
      @merchant_category_type = merchant_category_type
      @merchant_country_code = merchant_country_code
      @merchant_name = merchant_name
      @merchant_display_name = merchant_display_name
      @merchant_display_url = merchant_display_url
      @merchant_fee = merchant_fee
      @method_code = method_code
      @tags = tags
      @corporate_transaction_ids = corporate_transaction_ids
      @status = status
      @updated = updated
      @created = created

    end

    # # Retrieve a specific CorporatePurchase
    #
    # Receive a single CorporatePurchase object previously created in the Stark Bank API by its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - CorporatePurchase object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve CorporatePurchases
    #
    # Receive a generator of CorporatePurchases objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 09)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - merchant_category_types [list of strings, default nil]: merchant category type. ex: "health"
    # - holder_ids [list of strings, default nil]: card holder IDs. ex: ["5656565656565656", "4545454545454545"]
    # - card_ids [list of strings, default nil]: card  IDs. ex: ["5656565656565656", "4545454545454545"]
    # - status [list of strings, default nil]: filter for status of retrieved objects. ex: ['approved', 'canceled', 'denied', 'confirmed', 'voided']
    # - ids [list of strings, default nil]: purchase IDs. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of CorporatePurchases objects with updated attributes
    def self.query(ids: nil, limit: nil, after: nil, before: nil, merchant_category_types: nil, holder_ids: nil, card_ids: nil,
                   status: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_stream(
        ids: ids,
        limit: limit,
        after: after,
        before: before,
        merchant_category_types: merchant_category_types,
        holder_ids: holder_ids,
        card_ids: card_ids,
        status: status,
        user: user,
        **resource
      )
    end

    # # Retrieve paged CorporatePurchases
    #
    # Receive a list of up to 100 CorporatePurchases objects previously created in the Stark Bank API and the cursor
    # to the next page. Use this function instead of query if you want to manually page your invoices.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call.
    # - limit [integer, default 100]: maximum number of objects to be retrieved. Max = 100. ex: 35
    # - after [Date or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
    # - before [Date or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
    # - merchant_category_types [list of strings, default nil]: merchant category type. ex: "health"
    # - holder_ids [list of strings, default nil]: card holder IDs. ex: ["5656565656565656", "4545454545454545"]
    # - card_ids [list of strings, default nil]: card  IDs. ex: ["5656565656565656", "4545454545454545"]
    # - status [list of strings, default nil]: filter for status of retrieved objects. ex: ['approved', 'canceled', 'denied', 'confirmed', 'voided']
    # - ids [list of strings, default nil]: purchase IDs. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - list of CorporatePurchases objects with updated attributes
    # - cursor to retrieve the next page of CorporatePurchases objects
    def self.page(cursor: nil, ids: nil, limit: nil, after: nil, before: nil, merchant_category_types: nil, holder_ids: nil,
                  card_ids: nil, status: nil, user: nil)
      after = StarkCore::Utils::Checks.check_date(after)
      before = StarkCore::Utils::Checks.check_date(before)
      StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        ids: ids,
        limit: limit,
        after: after,
        before: before,
        merchant_category_types: merchant_category_types,
        holder_ids: holder_ids,
        card_ids: card_ids,
        status: status,
        user: user,
        **resource
      )
    end

    # # Create a single verified CorporatePurchase authorization request from a content string
    #
    # Use this method to parse and verify the authenticity of the authorization request received at the informed endpoint.
    # Authorization requests are posted to your registered endpoint whenever CorporatePurchases are received.
    # They present CorporatePurchase data that must be analyzed and answered with approval or declination.
    # If the provided digital signature does not check out with the StarkBank public key, a stark.exception.InvalidSignatureException will be raised.
    # If the authorization request is not answered within 2 seconds or is not answered with an HTTP status code 200 the
    # CorporatePurchase will go through the pre-configured stand-in validation.
    #
    # ## Parameters (required):
    # - content [string]: response content from request received at user endpoint (not parsed)
    # - signature [string]: base-64 digital signature received at response header 'Digital-Signature'
    #
    # # ## Parameters (optional):
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - Parsed CorporatePurchase object
    def self.parse(content:, signature:, user: nil)
      StarkBank::Utils::Parse.parse_and_verify(
        content: content,
        signature: signature,
        user: user,
        key: nil,
        resource: resource
      )
    end

    # # Helps you respond CorporatePurchase requests
    #
    # ## Parameters (required):
    # - status [string]: sub-issuer response to the authorization. ex: 'approved' or 'denied'
    #
    # ## Parameters (conditionally required):
    # - reason [string]: denial reason. Options: 'other', 'blocked', 'lostCard', 'stolenCard', 'invalidPin', 'invalidCard', 'cardExpired', 'corporateError', 'concurrency', 'standInDenial', 'subIssuerError', 'invalidPurpose', 'invalidZipCode', 'invalidWalletId', 'inconsistentCard', 'settlementFailed', 'cardRuleMismatch', 'invalidExpiration', 'prepaidInstallment', 'holderRuleMismatch', 'insufficientBalance', 'tooManyTransactions', 'invalidSecurityCode', 'invalidPaymentMethod', 'confirmationDeadline', 'withdrawalAmountLimit', 'insufficientCardLimit', 'insufficientHolderLimit'
    #
    # # ## Parameters (optional):
    # - amount [integer, default nil]: amount in cents that was authorized. ex: 1234 (= R$ 12.34)
    # - tags [list of strings, default nil]: tags to filter retrieved object. ex: ['tony', 'stark']
    #
    # ## Return:
    # - Dumped JSON string that must be returned to us on the CorporatePurchase request
    def self.response(
      status:, reason: nil, amount: nil, tags: nil
    )
      params = {
        'status': status,
        'reason': reason,
        'amount': amount,
        'tags': tags
      }

      params.to_json
    end

    def self.resource
      {
        resource_name: 'CorporatePurchase',
        resource_maker: proc { |json|
          CorporatePurchase.new(
            id: json['id'],
            holder_id: json['holder_id'],
            holder_name: json['holder_name'],
            center_id: json['center_id'],
            card_id: json['card_id'],
            card_ending: json['card_ending'],
            description: json['description'],
            amount: json['amount'],
            tax: json['tax'],
            corporate_amount: json['corporate_amount'],
            corporate_currency_code: json['corporate_currency_code'],
            corporate_currency_symbol: json['corporate_currency_symbol'],
            merchant_amount: json['merchant_amount'],
            merchant_currency_code: json['merchant_currency_code'],
            merchant_currency_symbol: json['merchant_currency_symbol'],
            merchant_category_code: json['merchant_category_code'],
            merchant_category_type: json['merchant_category_type'],
            merchant_country_code: json['merchant_country_code'],
            merchant_name: json['merchant_name'],
            merchant_display_name: json['merchant_display_name'],
            merchant_display_url: json['merchant_display_url'],
            merchant_fee: json['merchant_fee'],
            method_code: json['method_code'],
            tags: json['tags'],
            corporate_transaction_ids: json['corporate_transaction_ids'],
            status: json['status'],
            updated: json['updated'],
            created: json['created'],
          )
        }
      }
    end
  end
end
