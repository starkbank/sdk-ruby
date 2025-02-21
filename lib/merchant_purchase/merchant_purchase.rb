require 'starkcore'
require_relative '../utils/rest'


module StarkBank
    class MerchantPurchase < StarkCore::Utils::Resource
        attr_reader :amount, :billing_city, :billing_country_code, :billing_state_code, :billing_street_line1, :billing_street_line2, :billing_zip_code, :card_ending, :card_id, :challenge_mode, :challenge_url, :created, :currency_code, :end_to_end_id, :fee, :funding_type, :holder_email, :holder_name, :holder_phone, :id, :installment_count, :metadata, :network, :source, :status, :tags, :updated

        def initialize(
            amount:, funding_type:, card_id:, billing_city: nil, billing_country_code: nil, billing_state_code: nil, billing_street_line1: nil, billing_street_line2: nil, billing_zip_code: nil, card_ending: nil, challenge_mode: nil, challenge_url: nil, created: nil, currency_code: nil, end_to_end_id: nil, fee: nil, holder_email: nil, holder_name: nil, holder_phone: nil, id: nil, installment_count: nil, metadata: nil, network: nil, source: nil, status: nil, tags: nil, updated: nil
        )
            super(id)
            @amount = amount
            @billing_city = billing_city
            @billing_country_code = billing_country_code
            @billing_state_code = billing_state_code
            @billing_street_line1 = billing_street_line1
            @billing_street_line2 = billing_street_line2
            @billing_zip_code = billing_zip_code
            @card_ending = card_ending
            @card_id = card_id
            @challenge_mode = challenge_mode
            @challenge_url = challenge_url
            @created = StarkCore::Utils::Checks.check_datetime(created)
            @currency_code = currency_code
            @end_to_end_id = end_to_end_id
            @fee = fee
            @funding_type = funding_type
            @holder_email = holder_email
            @holder_name = holder_name
            @holder_phone = holder_phone
            @installment_count = installment_count
            @metadata = metadata
            @network = network
            @source = source
            @status = status
            @tags = tags
            @updated = StarkCore::Utils::Checks.check_datetime(updated)
        end

        def self.resource
            {
            resource_name: 'MerchantPurchase',
            resource_maker: proc { |json| 
                MerchantPurchase.new(
                id: json['id'],
                amount: json['amount'],
                billing_city: json['billingCity'],
                billing_country_code: json['billingCountryCode'],
                billing_state_code: json['billingStateCode'],
                billing_street_line1: json['billingStreetLine1'],
                billing_street_line2: json['billingStreetLine2'],
                billing_zip_code: json['billingZipCode'],
                card_ending: json['cardEnding'],
                card_id: json['cardId'],
                challenge_mode: json['challengeMode'],
                challenge_url: json['challengeUrl'],
                created: json['created'],
                currency_code: json['currencyCode'],
                end_to_end_id: json['endToEndId'],
                fee: json['fee'],
                funding_type: json['fundingType'],
                holder_email: json['holderEmail'],
                holder_name: json['holderName'],
                holder_phone: json['holderPhone'],
                installment_count: json['installmentCount'],
                metadata: json['metadata'],
                network: json['network'],
                source: json['source'],
                status: json['status'],
                tags: json['tags'],
                updated: json['updated']
                )
            }
            }
        end

        def self.create(purchase, user: nil)
            StarkBank::Utils::Rest.post_single(entity: purchase, resource_name: 'MerchantPurchase', user: user, **resource)
        end

        def self.get(id, user: nil)
            StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
        end

        def self.query(limit: nil, status: nil, tags: nil, ids: nil, after: nil, before: nil, user: nil)
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

        def self.page(cursor: nil, limit: nil, status: nil, tags: nil, ids: nil, after: nil, before: nil, user: nil)
            StarkBank::Utils::Rest.get_page(
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

        def self.update(id, payload, user: nil)
            StarkBank::Utils::Rest.patch_id(id: id, user: user, **resource, **payload)
        end
    end
end
