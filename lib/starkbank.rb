# frozen_string_literal: true

require_relative('key')
require_relative('user/project')
require_relative('balance/balance')
require_relative('transaction/transaction')
require_relative('invoice/invoice')
require_relative('invoice/log')
require_relative('dict_key/dict_key')
require_relative('deposit/deposit')
require_relative('deposit/log')
require_relative('boleto/boleto')
require_relative('boleto/log')
require_relative('boleto_holmes/boleto_holmes')
require_relative('boleto_holmes/log')
require_relative('transfer/transfer')
require_relative('transfer/log')
require_relative('boleto_payment/boleto_payment')
require_relative('boleto_payment/log')
require_relative('utility_payment/utility_payment')
require_relative('utility_payment/log')
require_relative('webhook/webhook')
require_relative('event/event')
require_relative('payment_request/payment_request')

# SDK to facilitate Ruby integrations with Stark Bank
module StarkBank
  @user = nil
  @language = 'en-US'
  class << self; attr_accessor :user, :language; end
end
