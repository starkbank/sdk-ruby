# frozen_string_literal: true

module StarkBank
  module Utils
    module URL
      # generates query string from hash
      def self.urlencode(params)
        return '' if params.nil?

        params = StarkBank::Utils::API.cast_json_to_api_format(params)
        return '' if params.empty?

        string_params = {}
        params.each do |key, value|
          string_params[key] = value.is_a?(Array) ? value.join(',') : value
        end

        query_list = []
        string_params.each do |key, value|
          query_list << "#{key}=#{value}"
        end
        '?' + query_list.join('&')
      end
    end
  end
end
