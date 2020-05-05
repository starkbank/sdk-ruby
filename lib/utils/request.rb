# frozen_string_literal: true

require('json')
require('starkbank-ecdsa')
require('net/http')
require_relative('url')
require_relative('checks')
require_relative('../error')

module StarkBank
  module Utils
    module Request
      class Response
        attr_reader :status, :content
        def initialize(status, content)
          @status = status
          @content = content
        end

        def json
          JSON.parse(@content)
        end
      end

      def self.fetch(method:, path:, payload: nil, query: nil, user: nil)
        user = Checks.check_user(user)

        base_url = {
          Environment::PRODUCTION => 'https://api.starkbank.com/',
          Environment::SANDBOX => 'https://sandbox.api.starkbank.com/'
        }[user.environment] + 'v2'

        url = "#{base_url}/#{path}#{StarkBank::Utils::URL.urlencode(query)}"
        uri = URI(url)

        access_time = Time.now.to_i
        body = payload.nil? ? '' : payload.to_json
        message = "#{user.access_id}:#{access_time}:#{body}"
        signature = EllipticCurve::Ecdsa.sign(message, user.private_key).toBase64

        case method
        when 'GET'
          req = Net::HTTP::Get.new(uri)
        when 'DELETE'
          req = Net::HTTP::Delete.new(uri)
        when 'POST'
          req = Net::HTTP::Post.new(uri)
          req.body = body
        when 'PATCH'
          req = Net::HTTP::Patch.new(uri)
          req.body = body
        when 'PUT'
          req = Net::HTTP::Put.new(uri)
          req.body = body
        else
          raise(ArgumentError, 'unknown HTTP method ' + method)
        end

        req['Access-Id'] = user.access_id
        req['Access-Time'] = access_time
        req['Access-Signature'] = signature
        req['Content-Type'] = 'application/json'
        req['User-Agent'] = "Ruby-#{RUBY_VERSION}-SDK-0.2.1"

        request = Net::HTTP.start(uri.hostname, use_ssl: true) { |http| http.request(req) }

        response = Response.new(Integer(request.code, 10), request.body)

        raise(StarkBank::Error::InternalServerError) if response.status == 500
        raise(StarkBank::Error::InputErrors, response.json['errors']) if response.status == 400
        raise(StarkBank::Error::UnknownError, response.content) unless response.status == 200

        response
      end
    end
  end
end
