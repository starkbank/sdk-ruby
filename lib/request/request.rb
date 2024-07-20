# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')
require_relative('../utils/parse')

module StarkBank

    class Request

        # # Retrieve any StarkBank resource
        #
        # Receive a json of resources previously created in StarkBank's API
        #
        # Parameters (required):
        #
        # - path [string]: StarkBank resource's route. ex: "/invoice/"
        # - query [json, default None]: Query parameters. ex: {"limit": 1, "status": paid}
        #
        # Parameters (optional):
        #
        # - user [Organization/Project object, default None]: Organization or Project object. Not necessary if StarkBank.user
        #     was set before function call
        #
        # Return:
        # - json of StarkBank objects with updated attributes

        def self.get(path:, query: nil, user: nil)
            content = StarkBank::Utils::Rest.get_raw(
                path: path,
                query: query,
                user: user,
                prefix: "Joker",
                raiseException: false
            )
        end

        # # Create any StarkBank resource
        #
        # Send a json to create StarkBank resources
        #
        # Parameters (required):
        #
        # - path [string]: StarkBank resource's route. ex: "/invoice/"
        # - body [json]: request parameters. ex: {"invoices": [{"amount": 100, "name": "Iron Bank S.A.", "taxId": "20.018.183/0001-80"}]}
        #
        # Parameters (optional):
        #
        # - user [Organization/Project object, default None]: Organization or Project object. Not necessary if StarkBank.user
        #     was set before function call
        # - query [json, default None]: Query parameters. ex: {"limit": 1, "status": paid}
        #
        # Return:
        #
        # - list of resources jsons with updated attributes

        def self.post(path:, payload:, query: nil, user: nil)
            content = StarkBank::Utils::Rest.post_raw(
                path: path,
                query: query,
                payload: payload,
                user: user,
                prefix: "Joker",
                raiseException: false
            )
        end

        # # Update any StarkBank resource
        #
        # Send a json with parameters of StarkBank resources to update them
        #
        # Parameters (required):
        #
        # - path [string]: StarkBank resource's route. ex: "/invoice/5699165527090460"
        # - body [json]: request parameters. ex: {"amount": 100}
        #
        # Parameters (optional):
        #
        # - user [Organization/Project object, default None]: Organization or Project object. Not necessary if StarkBank.user
        #     was set before function call
        #
        # Return:
        # - json of the resource with updated attributes

        def self.patch(path:, payload:, query: nil, user: nil)
            content = StarkBank::Utils::Rest.patch_raw(
                path: path,
                query: query,
                payload: payload,
                user: user,
                prefix: "Joker",
                raiseException: false
            )
        end

        # # Put any StarkBank resource
        #
        # Send a json with parameters of a StarkBank resources to create them. 
        # If the resource already exists, you will update it.
        #
        # Parameters (required):
        #
        # - path [string]: StarkBank resource's route. ex: "/split-profile"
        # - body [json]: request parameters. ex: {"profiles": [{"interval": day, "delay": "1"}]}
        #
        # Parameters (optional):
        #
        # - user [Organization/Project object, default None]: Organization or Project object. Not necessary if StarkBank.user
        #     was set before function call
        #
        # Return:
        # - json of the resource with updated attributes

        def self.put(path:, payload:, query: nil, user: nil)
            content = StarkBank::Utils::Rest.put_raw(
                path: path,
                query: query,
                payload: payload,
                user: user,
                prefix: "Joker",
                raiseException: false
            )
        end

        # # Delete any StarkBank resource
        #
        # Send parameters of StarkBank resources and delete them
        #
        # Parameters (required):
        #
        # - path [string]: StarkBank resource's route. ex: "/transfer/5699165527090460"
        #
        # Parameters (optional):
        #
        # - user [Organization/Project object, default None]: Organization or Project object. Not necessary if StarkBank.user
        #     was set before function call
        #
        # Return:
        # - json of the resource with updated attributes
        
        def self.delete(path:, query: nil, user: nil)
            content = StarkBank::Utils::Rest.delete_raw(
                path: path,
                query: query,
                user: user,
                prefix: "Joker",
                raiseException: false
            )
        end
    end
end