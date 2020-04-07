# frozen_string_literal: true

module StarkBank
  module Utils
    module Cache
      @starkbank_public_key = nil
      class << self; attr_accessor :starkbank_public_key; end
    end
  end
end
