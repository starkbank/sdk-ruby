# frozen_string_literal: true

require('utils/resource')
require('utils/checks')
require('starkbank-ecdsa')

module StarkBank
  class User < StarkBank::Utils::Resource
    attr_reader :pem, :environment
    def initialize(environment, id, private_key)
      super(id)
      @pem = StarkBank::Utils::Checks.check_private_key(private_key)
      @environment = StarkBank::Utils::Checks.check_environment(environment)
    end

    def access_id
      "#{self.class.name.split('::').last.downcase}/#{@id}"
    end

    def private_key
      EllipticCurve::PrivateKey.fromPem(@pem)
    end
  end
end
