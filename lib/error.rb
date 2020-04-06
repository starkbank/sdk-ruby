# frozen_string_literal: true

require('json')

module StarkBank
  module Error
    class Error < StandardError
      attr_reader :code, :message
      def initialize(code, message)
        @code = code
        @message = message
        super("#{code}: #{message}")
      end
    end

    class InputErrors < StandardError
      attr_reader :errors
      def initialize(content)
        errors = []
        content.each do |error|
          errors << Error.new(error['code'], error['message'])
        end
        @errors = errors

        super(error.to_json)
      end
    end

    class InternalServerError < StandardError
      def initialize(message = 'Houston, we have a problem.')
        super(message)
      end
    end

    class UnknownError < StandardError
      def initialize(message)
        super("Unknown exception encountered: #{message}")
      end
    end

    class InvalidSignatureError < StandardError
    end
  end
end
