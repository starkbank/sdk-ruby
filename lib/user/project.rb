# frozen_string_literal: true

require_relative('user')

module StarkBank
  # # Project object
  #
  # The Project object is an authentication entity for the SDK that is permanently
  # linked to a specific Workspace.
  # All requests to the Stark Bank API must be authenticated via an SDK user,
  # which must have been previously created at the Stark Bank website
  # [https://sandbox.web.starkbank.com] or [https://web.starkbank.com]
  # before you can use it in this SDK. Projects may be passed as the user parameter on
  # each request or may be defined as the default user at the start (See README).
  #
  # ## Parameters (required):
  # - id [string]: unique id required to identify project. ex: '5656565656565656'
  # - private_key [EllipticCurve.Project()]: PEM string of the private key linked to the project. ex: '-----BEGIN PUBLIC KEY-----\nMFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAEyTIHK6jYuik6ktM9FIF3yCEYzpLjO5X/\ntqDioGM+R2RyW0QEo+1DG8BrUf4UXHSvCjtQ0yLppygz23z0yPZYfw==\n-----END PUBLIC KEY-----'
  # - environment [string]: environment where the project is being used. ex: 'sandbox' or 'production'
  #
  # ## Attributes (return-only):
  # - name [string, default '']: project name. ex: 'MyProject'
  # - allowed_ips [list of strings]: list containing the strings of the ips allowed to make requests on behalf of this project. ex: ['190.190.0.50']
  # - pem [string]: private key in pem format. ex: '-----BEGIN PUBLIC KEY-----\nMFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAEyTIHK6jYuik6ktM9FIF3yCEYzpLjO5X/\ntqDioGM+R2RyW0QEo+1DG8BrUf4UXHSvCjtQ0yLppygz23z0yPZYfw==\n-----END PUBLIC KEY-----'
  class Project < StarkBank::User
    attr_reader :name, :allowed_ips
    def initialize(environment:, id:, private_key:, name: '', allowed_ips: nil)
      super(environment, id, private_key)
      @name = name
      @allowed_ips = allowed_ips
    end

    def access_id
      "project/#{@id}"
    end
  end
end
