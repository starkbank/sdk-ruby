require 'starkcore'
require_relative '../utils/rest'
require_relative 'merchant_session'


module StarkBank
  class MerchantSession
    class Purchase < StarkCore::Utils::Resource
      attr_reader :amount, :card_expiration, :card_number, :card_security_code, :holder_name, :funding_type, :holder_email, :holder_phone, :installment_count, :billing_country_code, :billing_city, :billing_state_code, :billing_street_line_1, :billing_street_line_2, :billing_zip_code, :metadata, :card_ending, :card_id, :challenge_mode, :challenge_url, :created, :currency_code, :end_to_end_id, :fee, :network, :source, :status, :tags, :updated
  
      def initialize(
        amount:, card_expiration:, card_number:, card_security_code:, holder_name:, funding_type:, id: nil, holder_email: nil, holder_phone: nil, installment_count: nil, billing_country_code: nil, billing_city: nil, billing_state_code: nil, billing_street_line_1: nil, billing_street_line_2: nil, billing_zip_code: nil, metadata: nil, card_ending: nil, card_id: nil, challenge_mode: nil, challenge_url: nil, created: nil, currency_code: nil, end_to_end_id: nil, fee: nil, network: nil, source: nil, status: nil, tags: nil, updated: nil
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
        @created = StarkCore::Utils::Checks.check_datetime(created)
        @currency_code = currency_code
        @end_to_end_id = end_to_end_id
        @fee = fee
        @network = network
        @source = source
        @status = status
        @tags = tags
        @updated = StarkCore::Utils::Checks.check_datetime(updated)
      end
  
      def self.resource
        {
          sub_resource_name: 'Purchase',
          sub_resource_maker: proc { |json|
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
              created: json['created'],
              currency_code: json['currency_code'],
              end_to_end_id: json['end_to_end_id'],
              fee: json['fee'],
              network: json['network'],
              source: json['source'],
              status: json['status'],
              tags: json['tags'],
              updated: json['updated']
            )
          }
        }
      end
    end
  end
end

