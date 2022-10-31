# frozen_string_literal: true

require_relative('../../starkcore/lib/starkcore')
require_relative('../utils/rest')

module StarkBank
  # # Workspace object
  #
  # Workspaces are bank accounts. They have independent balances, statements, operations and permissions.
  # The only property that is shared between your workspaces is that they are linked to your organization,
  # which carries your basic informations, such as tax ID, name, etc..
  #
  # ## Parameters (required):
  # - username [string]: Simplified name to define the workspace URL. This name must be unique across all Stark Bank Workspaces. Ex: 'starkbankworkspace'
  # - name [string]: Full name that identifies the Workspace. This name will appear when people access the Workspace on our platform, for example. Ex: 'Stark Bank Workspace'
  #
  # ## Parameters (optional):
  # - allowed_tax_ids [list of strings]: list of tax IDs that will be allowed to send Deposits to this Workspace. ex: ['012.345.678-90', '20.018.183/0001-80']
  #
  # ## Attributes:
  # - id [string, default nil]: unique id returned when the workspace is created. ex: '5656565656565656'
  class Workspace < StarkCore::Utils::Resource
    attr_reader :username, :name, :allowed_tax_ids, :id
    def initialize(username:, name:, allowed_tax_ids: nil, id: nil)
      super(id)
      @username = username
      @name = name
      @allowed_tax_ids = allowed_tax_ids
    end

    # # Create Workspace
    #
    # Send a Workspace for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - username [string]: Simplified name to define the workspace URL. This name must be unique across all Stark Bank Workspaces. Ex: 'starkbankworkspace'
    # - name [string]: Full name that identifies the Workspace. This name will appear when people access the Workspace on our platform, for example. Ex: 'Stark Bank Workspace'
    #
    # ## Parameters (optional):
    # - user [Organization object]: Organization object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Workspace object with updated attributes
    def self.create(username:, name:, user: nil, allowed_tax_ids: nil)
      StarkBank::Utils::Rest.post_single(entity: Workspace.new(username: username, name: name, allowed_tax_ids: allowed_tax_ids), user: user, **resource)
    end

    # # Retrieve a specific Workspace
    #
    # Receive a single Workspace object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Workspace object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve Workspaces
    #
    # Receive a generator of Workspace objects previously created in the Stark Bank API.
    # If no filters are passed and the user is an Organization, all of the Organization Workspaces
    # will be retrieved.
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - username [string]: query by the simplified name that defines the workspace URL. This name is always unique across all Stark Bank Workspaces. Ex: 'starkbankworkspace'
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of Workspace objects with updated attributes
    def self.query(limit: nil, username: nil, ids: nil, user: nil)
      StarkBank::Utils::Rest.get_stream(limit: limit, username: username, ids: ids, user: user, **resource)
    end

    # # Retrieve paged Workspaces
    #
    # Receive a list of up to 100 Workspace objects previously created in the Stark Bank API and the cursor to the next page.
    # Use this function instead of query if you want to manually page your requests.
    #
    # ## Parameters (optional):
    # - cursor [string, default nil]: cursor returned on the previous page function call
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - username [string]: query by the simplified name that defines the workspace URL. This name is always unique across all Stark Bank Workspaces. Ex: 'starkbankworkspace'
    # - ids [list of strings, default nil]: list of ids to filter retrieved objects. ex: ['5656565656565656', '4545454545454545']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - list of Workspace objects with updated attributes and cursor to retrieve the next page of Workspace objects
    def self.page(cursor: nil, limit: nil, username: nil, ids: nil, user: nil)
      return StarkBank::Utils::Rest.get_page(
        cursor: cursor,
        limit: limit, 
        username: username, 
        ids: ids, 
        user: user, 
        **resource
      )
    end

    # # Update an Workspace entity
    #
    # Update an Workspace entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: Workspace unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - username [string, default nil]: query by the simplified name that defines the workspace URL. This name is always unique across all Stark Bank Workspaces. Ex: 'starkbankworkspace'
    # - name [string, default nil]: Full name that identifies the Workspace. This name will appear when people access the Workspace on our platform, for example. Ex: 'Stark Bank Workspace'
    # - allowed_tax_ids [list of strings, default nil]: list of tax IDs that will be allowed to send Deposits to this Workspace. If empty, all are allowed. ex: ['012.345.678-90', '20.018.183/0001-80']
    # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - updated Workspace object
    def self.update(id, user: nil, username: nil, name: nil, allowed_tax_ids: nil)
      StarkBank::Utils::Rest.patch_id(id: id, user: user, username: username, name: name, allowed_tax_ids: allowed_tax_ids, **resource)
    end

    def self.resource
      {
        resource_name: 'Workspace',
        resource_maker: proc { |json|
          Workspace.new(
            id: json['id'],
            username: json['username'],
            name: json['name'],
            allowed_tax_ids: json['allowed_tax_ids']
          )
        }
      }
    end
  end
end
