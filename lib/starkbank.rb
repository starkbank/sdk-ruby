# frozen_string_literal: true

require_relative('key')
require_relative('user/project')
require_relative('ledger/balance')
require_relative('boleto/boleto')

# SDK to facilitate Ruby integrations with Stark Bank
module StarkBank
  @user = nil
  class << self; attr_accessor :user; end
end
