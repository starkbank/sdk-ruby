# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')

module StarkBank
  # # CardMethod object
  #
  # CardMethod's codes are used to define method filters in CorporateRules.
  #
  # ## Parameters (required):
  # - code [string]: method's code. Options: 'chip', 'token', 'server', 'manual', 'magstripe', 'contactless'
  #
  # Attributes (return-only):
  # - name [string]: method's name. ex: 'token'
  # - number [string]: method's number. ex: '81'
  class CardMethod < StarkCore::Utils::SubResource
    attr_reader :code, :name, :number
    def initialize(code:, name: nil, number: nil)
      @code = code
      @name = name
      @number = number
    end

    # # Retrieve CardMethods
    #
    # Receive a generator of CardMethod objects available in the Stark Bank API
    #
    # ## Parameters (optional):
    # - search [string, default nil]: keyword to search for code, name, number or short_code
    # - user [Organization/Project object, default nil]: Organization or Project object. Not necessary if starkbank.user was set before function call
    #
    # ## Return:
    # - generator of CardMethod objects with updated attributes
    def self.query(search: nil, user: nil)
      StarkBank::Utils::Rest.get_stream(
        search: search,
        user: user,
        **resource
      )
    end

    def self.resource
      {
        resource_name: 'CardMethod',
        resource_maker: proc { |json|
          CardMethod.new(
            code: json['code'],
            name: json['name'],
            number: json['number']
          )
        }
      }
    end
  end
end
