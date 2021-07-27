# frozen_string_literal: true

require('json')

module StarkBank
  module Error
    class StarkBankError < StandardError
      attr_reader :message
      def initialize(message)
        @message = message
        super(message)
      end
    end

    class Error < StarkBankError
      attr_reader :code, :message
      def initialize(code, message)
        @code = code
        @message = message
        super("#{code}: #{message}")
      end
    end

    class InputErrors < StarkBankError
      attr_reader :errors
      def initialize(content)
        errors = []
        content.each do |error|
          errors << Error.new(error['code'], error['message'])
        end
        @errors = errors

        super(content.to_json)
      end
    end

    class InternalServerError < StarkBankError
      def initialize(message = 'Houston, we have a problem.')
        super(message)
      end
    end

    class UnknownError < StarkBankError
      def initialize(message)
        super("Unknown exception encountered: #{message}")
      end
    end

    class InvalidSignatureError < StarkBankError
    end
  end
end
