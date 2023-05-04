# frozen_string_literal: true

require 'starkcore'
require_relative('../utils/rest')

module StarkBank
  # # MerchantCountry object
  #
  # MerchantCountry's codes are used to define countries filters in CorporateRules.
  #
  # ## Parameters (required):
  # - code [string]: country's code. ex: 'BRA'
  #
  # Attributes (return-only):
  # - name [string]: country's name. ex: 'Brazil'
  # - number [string]: country's number. ex: '076'
  # - short_code [string]: country's short code. ex: 'BR'
  class MerchantCountry < StarkCore::Utils::SubResource
    attr_reader :code, :short_code, :name, :number
    def initialize(code:, name: nil, number: nil, short_code: nil)
      @code = code
      @name = name
      @number = number
      @short_code = short_code
    end

    # # Retrieve MerchantCountries
    #
    # Receive a generator of MerchantCountry objects available in the Stark Bank API
    #
    # ## Parameters (optional):
    # - search [string, default nil]: keyword to search for code, name, number or short_code
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of MerchantCountry objects with updated attributes
    def self.query(search: nil, user: nil)
      StarkBank::Utils::Rest.get_stream(
        search: search,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'MerchantCountry',
        resource_maker: proc { |json|
          MerchantCountry.new(
            code: json['code'],
            name: json['name'],
            number: json['number'],
            short_code: json['short_code']
          )
        }
      }
    end
  end
end
