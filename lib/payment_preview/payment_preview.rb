# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')


module StarkBank
  # # PaymentPreview object
  #
  # A PaymentPreview is used to get information from a payment code before confirming the payment.
  # This resource can be used to preview BR Codes and bar codes of boleto, tax and utility payments
  #
  # ## Attributes (return-only):
  # - id [string]: Main identification of the payment. This should be the BR Code for Pix payments and lines or bar codes for payment slips. ex: '34191.09008 63571.277308 71444.640008 5 81960000000062', '00020126580014br.gov.bcb.pix0136a629532e-7693-4846-852d-1bbff817b5a8520400005303986540510.005802BR5908T'Challa6009Sao Paulo62090505123456304B14A'
  # - scheduled [DateTime or string]: intended payment date. Right now, this parameter only has effect on BrcodePreviews. ex: '2020-04-30'
  # - type [string]: Payment type. ex: 'brcode-payment', 'boleto-payment', 'utility-payment' or 'tax-payment'
  # - payment [BrcodePreview, BoletoPreview, UtilityPreview or TaxPreview]: Information preview of the informed payment.
  class PaymentPreview < StarkCore::Utils::Resource
    attr_reader :id, :scheduled, :type, :payment
    def initialize(id: nil, scheduled: nil, type: nil, payment: nil)
      super(id)
      @scheduled = StarkCore::Utils::Checks.check_date(scheduled)
      @type = type
      @payment = payment
      return if type.nil?

      resource = {
        'brcode-payment': StarkBank::PaymentPreview::BrcodePreview.resource,
        'boleto-payment': StarkBank::PaymentPreview::BoletoPreview.resource,
        'tax-payment': StarkBank::PaymentPreview::TaxPreview.resource,
        'utility-payment': StarkBank::PaymentPreview::UtilityPreview.resource
      }[type.to_sym]

      @payment = StarkCore::Utils::API.from_api_json(resource[:resource_maker], payment) unless resource.nil?
    end

    # # Create PaymentPreviews
    #
    # Send a list of PaymentPreviews objects for processing in the Stark Bank API
    #
    # ## Parameters (required):
    # - previews [list of PaymentPreviews objects]: list of PaymentPreviews objects to be created in the API
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of PaymentPreviews objects with updated attributes
    def self.create(previews, user: nil)
      StarkBank::Utils::Rest.post(entities: previews, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'PaymentPreview',
        resource_maker: proc { |json|
          PaymentPreview.new(
            id: json['id'],
            scheduled: json['scheduled'],
            type: json['type'],
            payment: json['payment']
          )
        }
      }
    end
  end
end
