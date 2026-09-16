# frozen_string_literal: true

require('starkcore')

module StarkBank
  class MerchantSession
    # # MerchantSession::Purchase object
    #
    # A MerchantSession::Purchase is the card purchase created against a previously created MerchantSession, through
    # the MerchantSession.purchase function, identified by the session's uuid.
    #
    # ## Parameters (required):
    # - amount [integer]: MerchantSession::Purchase value in cents. ex: 1234 (= R$ 12.34)
    # - card_expiration [string]: card expiration date. ex: '2032-01'
    # - card_number [string]: card number. ex: '5579718869788870'
    # - card_security_code [string]: card verification value. ex: '123'
    # - holder_name [string]: card holder name. ex: 'Tony Stark'
    # - funding_type [string]: type of funding used. ex: 'credit', 'debit'
    #
    # ## Parameters (optional):
    # - holder_email [string, default nil]: card holder email. ex: 'tony@starkbank.com'
    # - holder_phone [string, default nil]: card holder phone number. ex: '+5511988887777'
    # - holder_id [string, default nil]: unique id of the card holder, when applicable. ex: '5656565656565656'
    # - installment_count [integer, default nil]: number of installments the purchase is split into. ex: 1
    # - billing_country_code [string, default nil]: billing country code. ex: 'BRA'
    # - billing_city [string, default nil]: billing city. ex: 'Sao Paulo'
    # - billing_state_code [string, default nil]: billing state code. ex: 'SP'
    # - billing_street_line_1 [string, default nil]: billing street line 1. ex: 'Av. Faria Lima, 1811'
    # - billing_street_line_2 [string, default nil]: billing street line 2. ex: 'Apto 401'
    # - billing_zip_code [string, default nil]: billing zip code. ex: '01452-002'
    # - metadata [dictionary, default nil]: additional 3DS metadata sent by the merchant's browser/app.
    # - soft_descriptor [string, default nil]: text that will be shown in the holder's bank statement. ex: 'my-store'
    # - tags [list of strings, default nil]: list of strings for tagging. ex: ['tony', 'stark']
    #
    # ## Attributes (return-only):
    # - id [string]: unique id returned when MerchantSession::Purchase is created. ex: '5656565656565656'
    # - card_ending [string]: last 4 digits of the card used. ex: '1234'
    # - card_id [string]: unique id of the card used, when applicable. ex: '5656565656565656'
    # - challenge_mode [string]: whether 3DS holder verification was used. ex: 'enabled', 'disabled'
    # - challenge_url [string]: URL to the 3DS challenge, when applicable.
    # - currency_code [string]: currency of the purchase. ex: 'BRL'
    # - end_to_end_id [string]: unique transaction id for the acquirer network.
    # - fee [integer]: fee charged when the MerchantSession::Purchase is processed. ex: 200 (= R$ 2.00)
    # - network [string]: card network flag. ex: 'visa', 'mastercard'
    # - source [string]: locator of the entity that generated the purchase. ex: 'merchant-session/{sessionId}'
    # - status [string]: current MerchantSession::Purchase status. ex: 'approved', 'confirmed', 'canceled', 'voided'
    # - created [DateTime]: creation datetime for the MerchantSession::Purchase. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
    # - updated [DateTime]: latest update datetime for the MerchantSession::Purchase. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
    class Purchase < StarkCore::Utils::Resource
      attr_reader :id, :amount, :card_expiration, :card_number, :card_security_code, :holder_name, :funding_type,
                  :holder_email, :holder_phone, :holder_id, :installment_count, :billing_country_code, :billing_city,
                  :billing_state_code, :billing_street_line_1, :billing_street_line_2, :billing_zip_code, :metadata,
                  :card_ending, :card_id, :challenge_mode, :challenge_url, :currency_code, :end_to_end_id, :fee,
                  :network, :soft_descriptor, :source, :status, :tags, :created, :updated
      def initialize(
        amount:, card_expiration:, card_number:, card_security_code:, holder_name:, funding_type:, id: nil,
        holder_email: nil, holder_phone: nil, holder_id: nil, installment_count: nil, billing_country_code: nil,
        billing_city: nil, billing_state_code: nil, billing_street_line_1: nil, billing_street_line_2: nil,
        billing_zip_code: nil, metadata: nil, card_ending: nil, card_id: nil, challenge_mode: nil, challenge_url: nil,
        currency_code: nil, end_to_end_id: nil, fee: nil, network: nil, soft_descriptor: nil, source: nil,
        status: nil, tags: nil, created: nil, updated: nil
      )
        super(id)
        @amount = amount
        @card_expiration = card_expiration
        @card_number = card_number
        @card_security_code = card_security_code
        @holder_name = holder_name
        @funding_type = funding_type
        @holder_email = holder_email
        @holder_phone = holder_phone
        @holder_id = holder_id
        @installment_count = installment_count
        @billing_country_code = billing_country_code
        @billing_city = billing_city
        @billing_state_code = billing_state_code
        @billing_street_line_1 = billing_street_line_1
        @billing_street_line_2 = billing_street_line_2
        @billing_zip_code = billing_zip_code
        @metadata = metadata
        @card_ending = card_ending
        @card_id = card_id
        @challenge_mode = challenge_mode
        @challenge_url = challenge_url
        @currency_code = currency_code
        @end_to_end_id = end_to_end_id
        @fee = fee
        @network = network
        @soft_descriptor = soft_descriptor
        @source = source
        @status = status
        @tags = tags
        @created = StarkCore::Utils::Checks.check_datetime(created)
        @updated = StarkCore::Utils::Checks.check_datetime(updated)
      end

      def self.resource
        {
          resource_name: 'Purchase',
          resource_maker: proc { |json|
            Purchase.new(
              id: json['id'],
              amount: json['amount'],
              card_expiration: json['card_expiration'],
              card_number: json['card_number'],
              card_security_code: json['card_security_code'],
              holder_name: json['holder_name'],
              funding_type: json['funding_type'],
              holder_email: json['holder_email'],
              holder_phone: json['holder_phone'],
              holder_id: json['holder_id'],
              installment_count: json['installment_count'],
              billing_country_code: json['billing_country_code'],
              billing_city: json['billing_city'],
              billing_state_code: json['billing_state_code'],
              billing_street_line_1: json['billing_street_line_1'],
              billing_street_line_2: json['billing_street_line_2'],
              billing_zip_code: json['billing_zip_code'],
              metadata: json['metadata'],
              card_ending: json['card_ending'],
              card_id: json['card_id'],
              challenge_mode: json['challenge_mode'],
              challenge_url: json['challenge_url'],
              currency_code: json['currency_code'],
              end_to_end_id: json['end_to_end_id'],
              fee: json['fee'],
              network: json['network'],
              soft_descriptor: json['soft_descriptor'],
              source: json['source'],
              status: json['status'],
              tags: json['tags'],
              created: json['created'],
              updated: json['updated']
            )
          }
        }
      end
    end
  end
end
