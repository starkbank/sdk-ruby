# frozen_string_literal: true
require_relative("sub_resource")

module StarkBank
  module Utils
    class Resource < StarkBank::Utils::SubResource
      attr_reader :id
      def initialize(id = nil)
        @id = id
      end
    end
  end
end
