# frozen_string_literal: true

require_relative('workspace/workspace')
require_relative('balance/balance')
require_relative('transaction/transaction')
require_relative('invoice/invoice')
require_relative('invoice/log')
require_relative('invoice/payment')
require_relative('dict_key/dict_key')
require_relative('dynamic_brcode/dynamic_brcode')
require_relative('deposit/deposit')
require_relative('deposit/log')
require_relative('brcode_payment/brcode_payment')
require_relative('brcode_payment/rule')
require_relative('brcode_payment/log')
require_relative('boleto/boleto')
require_relative('boleto/log')
require_relative('boleto_holmes/boleto_holmes')
require_relative('boleto_holmes/log')
require_relative('transfer/transfer')
require_relative('transfer/log')
require_relative('transfer/rule')
require_relative('boleto_payment/boleto_payment')
require_relative('boleto_payment/log')
require_relative('utility_payment/utility_payment')
require_relative('utility_payment/log')
require_relative('tax_payment/tax_payment')
require_relative('tax_payment/log')
require_relative('darf_payment/darf_payment')
require_relative('darf_payment/log')
require_relative('webhook/webhook')
require_relative('event/event')
require_relative('event/attempt')
require_relative('payment_request/payment_request')
require_relative('payment_preview/payment_preview')
require_relative('payment_preview/brcode_preview')
require_relative('payment_preview/boleto_preview')
require_relative('payment_preview/tax_preview')
require_relative('payment_preview/utility_preview')
require_relative('institution/institution')

# SDK to facilitate Ruby integrations with Stark Bank
module StarkBank

  API_VERSION = 'v2'
  SDK_VERSION = '2.6.0'
  HOST = "bank"
  public_constant :API_VERSION, :SDK_VERSION, :HOST;

  @user = nil
  @language = 'en-US'
  @timeout = 15
  class << self; attr_accessor :user, :language, :timeout; end

  Project = StarkCore::Project
  Organization = StarkCore::Organization
  Key = StarkCore::Key

end
