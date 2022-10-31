# frozen_string_literal: true

require_relative('../../starkcore/lib/starkcore')
require_relative('../utils/rest')

module StarkBank
  # # Institution object
  #
  # This resource is used to get information on the institutions that are recognized by the Brazilian Central Bank.
  # Besides the display name and full name, they also include the STR code (used for TEDs) and the SPI Code
  # (used for Pix) for the institutions. Either of these codes may be empty if the institution is not registered on
  # that Central Bank service.
  #
  # ## Attributes (return-only):
  # - display_name [string]: short version of the institution name that should be displayed to end users. ex: 'Stark Bank'
  # - name [string]: full version of the institution name. ex: 'Stark Bank S.A.'
  # - spi_code [string]: SPI code used to identify the institution on Pix transactions. ex: '20018183'
  # - str_code [string]: STR code used to identify the institution on TED transactions. ex: '123'
  class Institution < StarkCore::Utils::SubResource
    attr_reader :display_name, :name, :spi_code, :str_code
    def initialize(display_name: nil, name: nil, spi_code: nil, str_code: nil)
      @display_name = display_name
      @name = name
      @spi_code = spi_code
      @str_code = str_code
    end

    # # Retrieve Bacen Institutions
    #
    # Receive a list of Institution objects that are recognized by the Brazilian Central bank for Pix and TED transactions
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - search [string, default nil]: part of the institution name to be searched. ex: 'stark'
    # - spi_codes [list of strings, default nil]: list of SPI (Pix) codes to be searched. ex: ['20018183']
    # - str_codes [list of strings, default nil]: list of STR (TED) codes to be searched. ex: ['260']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of Institution objects with updated attributes
    def self.query(limit: nil, search: nil, spi_codes: nil, str_codes: nil, user: nil)
      StarkBank::Utils::Rest.get_page(
          limit: limit,
          search: search, 
          spi_codes: spi_codes, 
          str_codes: str_codes,
          user: user,
          **resource
      ).first
    end

    def self.resource
      {
        resource_name: 'Institution',
        resource_maker: proc { |json|
          Institution.new(      
            display_name: json['display_name'],
            name: json['name'],
            spi_code: json['spi_code'],
            str_code: json['str_code']
          )
        }
      }
    end
  end
end
