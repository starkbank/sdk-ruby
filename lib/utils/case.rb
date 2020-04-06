# frozen_string_literal: true

module StarkBank
  module Utils
    module Case
      def self.camel_to_snake(camel)
        camel.to_s.gsub(/([a-z])([A-Z\d])/, '\1_\2').downcase
      end

      def self.snake_to_camel(snake)
        camel = snake.split('_').map(&:capitalize).join
        camel[0] = camel[0].downcase
        camel
      end

      def self.camel_to_kebab(camel)
        camel_to_snake(camel).tr('_', '-')
      end
    end
  end
end
