# frozen_string_literal: true

require_relative('user')

module StarkBank
  # # Organization object
  # The Organization object is an authentication entity for the SDK that
  # represents your entire Organization, being able to access any Workspace
  # underneath it and even create new Workspaces. Only a legal representative
  # of your organization can register or change the Organization credentials.
  # All requests to the Stark Bank API must be authenticated via an SDK user,
  # which must have been previously created at the Stark Bank website
  # [https://sandbox.web.starkbank.com] or [https://web.starkbank.com]
  # before you can use it in this SDK. Organizations may be passed as the user parameter on
  # each request or may be defined as the default user at the start (See README).
  # If you are accessing a specific Workspace using Organization credentials, you should
  # specify the workspace ID when building the Organization object or by request, using
  # the organization.set_workspace(workspace_id) method, which creates a copy of the organization
  # object with the altered workspace ID. If you are listing or creating new Workspaces, the
  # workspace_id should be nil.
  #
  # ## Parameters (required):
  # - id [string]: unique id required to identify organization. ex: '5656565656565656'
  # - private_key [EllipticCurve.Organization()]: PEM string of the private key linked to the organization. ex: '-----BEGIN PUBLIC KEY-----\nMFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAEyTIHK6jYuik6ktM9FIF3yCEYzpLjO5X/\ntqDioGM+R2RyW0QEo+1DG8BrUf4UXHSvCjtQ0yLppygz23z0yPZYfw==\n-----END PUBLIC KEY-----'
  # - environment [string]: environment where the organization is being used. ex: 'sandbox' or 'production'
  # - workspace_id [string]: unique id of the accessed Workspace, if any. ex: nil or '4848484848484848'
  #
  # ## Attributes (return-only):
  # - pem [string]: private key in pem format. ex: '-----BEGIN PUBLIC KEY-----\nMFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAEyTIHK6jYuik6ktM9FIF3yCEYzpLjO5X/\ntqDioGM+R2RyW0QEo+1DG8BrUf4UXHSvCjtQ0yLppygz23z0yPZYfw==\n-----END PUBLIC KEY-----'
  class Organization < StarkBank::User
    attr_reader :id, :private_key, :environment, :workspace_id, :pem
    def initialize(id:, environment:, private_key:, workspace_id: nil)
      super(environment, id, private_key)
      @workspace_id = workspace_id
    end

    def access_id
      if @workspace_id
        "organization/#{@id}/workspace/#{@workspace_id}"
      else
        "organization/#{id}"
      end
    end

    def with_workspace(workspace_id)
      Organization.new(
        id: @id,
        environment: @environment,
        private_key: @private_key,
        workspace_id: @workspace_id
      )
    end
  end
end
