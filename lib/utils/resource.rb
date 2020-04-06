module StarkBank
  module Utils
    class Resource
      attr_reader :id
      def initialize(id = nil)
        @id = id
      end
    end
  end
end
