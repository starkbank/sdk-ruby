# frozen_string_literal: true

require('fileutils')
require('starkbank-ecdsa')

module StarkBank
  module Key
    # # Generate a new key pair
    # Generates a secp256k1 ECDSA private/public key pair to be used in the API
    # authentications
    #
    # ## Parameters (optional):
    # - path [string]: path to save the keys .pem files. No files will be saved if this parameter isn't provided
    #
    # ## Return:
    # - private and public key pems
    def self.create(path = nil)
      private_key = EllipticCurve::PrivateKey.new
      public_key = private_key.publicKey

      private_key_pem = private_key.toPem
      public_key_pem = public_key.toPem

      unless path.nil?
        FileUtils.mkdir_p(path)
        File.write(File.join(path, 'private.pem'), private_key_pem)
        File.write(File.join(path, 'public.pem'), public_key_pem)
      end

      [private_key_pem, public_key_pem]
    end
  end
end
