# frozen_string_literal: true

require('starkbank-ecdsa')
require_relative('../../starkcore/lib/starkcore')

module StarkBank
  class User < StarkCore::Utils::Resource
    attr_reader :pem, :environment
    def initialize(environment, id, private_key)
      super(id)
      @pem = StarkCore::Utils::Checks.check_private_key(private_key)
      @environment = StarkCore::Utils::Checks.check_environment(environment)
    end

    def private_key
      EllipticCurve::PrivateKey.fromPem(@pem)
    end
  end
end
