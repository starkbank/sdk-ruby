# frozen_string_literal: true

require('utils/resource')
require('utils/environment')
require('starkbank-ecdsa')

module StarkBank
  module Utils
    class Checks
      def self.check_environment(environment)
        environments = StarkBank::Utils::Environment.constants(false).map { |c| StarkBank::Utils::Environment.const_get(c) }
        raise(ArgumentError, "Select a valid environment: #{environments.join(', ')}") unless environments.include?(environment)

        environment
      end

      def self.check_private_key(pem)
        EllipticCurve::PrivateKey.fromPem(pem)
        pem
      rescue
        raise(ArgumentError, 'Private-key must be a valid secp256k1 ECDSA string in pem format')
      end
    end
  end
end
