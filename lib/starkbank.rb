# frozen_string_literal: true

require_relative('key')
require_relative('user/project')
require_relative('ledger/balance')
require_relative('ledger/transaction')
require_relative('boleto/boleto')
require_relative('boleto/log')
require_relative('transfer/transfer')
require_relative('transfer/log')
require_relative('payment/boleto/boleto')
require_relative('payment/boleto/log')

# SDK to facilitate Ruby integrations with Stark Bank
module StarkBank
  @user = nil
  class << self; attr_accessor :user; end
end
