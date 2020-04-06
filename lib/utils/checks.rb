# frozen_string_literal: true

require('starkbank-ecdsa')
require_relative('../user/user')
require_relative('environment')

module StarkBank
  module Utils
    class Checks
      def self.check_user(user)
        return user if user.is_a?(StarkBank::User)

        user = user.nil? ? StarkBank.user : user
        raise(ArgumentError, 'A user is required to access our API. Check our README: https://github.com/starkbank/sdk-ruby/') if user.nil?

        user
      end

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
