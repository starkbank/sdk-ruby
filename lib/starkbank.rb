# frozen_string_literal: true

require_relative('key')
require_relative('user/project')
require_relative('balance/balance')
require_relative('transaction/transaction')
require_relative('boleto/boleto')
require_relative('boleto/log')
require_relative('transfer/transfer')
require_relative('transfer/log')
require_relative('boleto_payment/boleto_payment')
require_relative('boleto_payment/log')
require_relative('utility_payment/utility_payment')
require_relative('utility_payment/log')
require_relative('webhook/webhook')
require_relative('event/event')

# SDK to facilitate Ruby integrations with Stark Bank
module StarkBank
  @user = nil
  class << self; attr_accessor :user; end
end
