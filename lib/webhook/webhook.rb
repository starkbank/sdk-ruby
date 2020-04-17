# frozen_string_literal: true

require_relative('../utils/resource')
require_relative('../utils/rest')
require_relative('../utils/checks')

module StarkBank
  # # Webhook subscription object
  #
  # A Webhook is used to subscribe to notification events on a user-selected endpoint.
  # Currently available services for subscription are transfer, boleto, boleto-payment,
  # and utility-payment
  #
  # ## Parameters (required):
  # - url [string]: Url that will be notified when an event occurs.
  # - subscriptions [list of strings]: list of any non-empty combination of the available services. ex: ['transfer', 'boleto-payment']
  #
  # ## Attributes:
  # - id [string, default nil]: unique id returned when the log is created. ex: '5656565656565656'
  class Webhook < StarkBank::Utils::Resource
    attr_reader :url, :subscriptions, :id
    def initialize(url:, subscriptions:, id: nil)
      super(id)
      @url = url
      @subscriptions = subscriptions
    end

    # # Create Webhook subscription
    #
    # Send a single Webhook subscription for creation in the Stark Bank API
    #
    # ## Parameters (required):
    # - url [string]: url to which notification events will be sent to. ex: 'https://webhook.site/60e9c18e-4b5c-4369-bda1-ab5fcd8e1b29'
    # - subscriptions [list of strings]: list of any non-empty combination of the available services. ex: ['transfer', 'boleto-payment']
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Webhook object with updated attributes
    def self.create(url:, subscriptions:, id: nil, user: nil)
      StarkBank::Utils::Rest.post_single(entity: Webhook.new(url: url, subscriptions: subscriptions), user: user, **resource)
    end

    # # Retrieve a specific Webhook subscription
    #
    # Receive a single Webhook subscription object previously created in the Stark Bank API by passing its id
    #
    # ## Parameters (required):
    # - id [string]: object unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - Webhook object with updated attributes
    def self.get(id, user: nil)
      StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
    end

    # # Retrieve Webhook subcriptions
    #
    # Receive a generator of Webhook subcription objects previously created in the Stark Bank API
    #
    # ## Parameters (optional):
    # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
    # - user [Project object, default nil]: Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - generator of Webhook objects with updated attributes
    def self.query(limit: nil, user: nil)
      StarkBank::Utils::Rest.get_list(user: user, limit: limit, **resource)
    end

    # # Delete a Webhook entity
    #
    # Delete a Webhook entity previously created in the Stark Bank API
    #
    # ## Parameters (required):
    # - id [string]: Webhook unique id. ex: '5656565656565656'
    #
    # ## Parameters (optional):
    # - user [Project object]: Project object. Not necessary if StarkBank.user was set before function call
    #
    # ## Return:
    # - deleted Webhook with updated attributes
    def self.delete(id, user: nil)
      StarkBank::Utils::Rest.delete_id(id: id, user: user, **resource)
    end

    def self.resource
      {
        resource_name: 'Webhook',
        resource_maker: proc { |json|
          Webhook.new(
            id: json['id'],
            url: json['url'],
            subscriptions: json['subscriptions']
          )
        }
      }
    end
  end
end
