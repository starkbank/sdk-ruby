# frozen_string_literal: true

require('starkbank-ecdsa')
require_relative('../utils/resource')

module StarkBank
  class User < StarkBank::Utils::Resource
    attr_reader :pem, :environment
    def initialize(environment, id, private_key)
      require_relative('../utils/checks')
      super(id)
      @pem = StarkBank::Utils::Checks.check_private_key(private_key)
      @environment = StarkBank::Utils::Checks.check_environment(environment)
    end

    def private_key
      EllipticCurve::PrivateKey.fromPem(@pem)
    end
  end
end
