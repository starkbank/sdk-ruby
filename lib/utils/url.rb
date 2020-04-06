# frozen_string_literal: true

module StarkBank
  module Utils
    module URL
      # generates query string from hash
      def self.urlencode(params)
        return '' if params.nil?

        clean_params = {}
        params.each do |key, value|
          next if value.nil?

          clean_params[StarkBank::Utils::Case.snake_to_camel(key)] = value.is_a?(Array) ? value.join(',') : value
        end

        return '' if clean_params.empty?

        query_list = []
        clean_params.each do |key, value|
          query_list << "#{key}=#{value}"
        end
        '?' + query_list.join('&')
      end
    end
  end
end
