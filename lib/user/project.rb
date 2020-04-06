# frozen_string_literal: true

require_relative('user')

module StarkBank
  class Project < StarkBank::User
    attr_reader :name, :allowed_ips
    def initialize(environment, id, private_key, name: '', allowed_ips: nil)
      super(environment, id, private_key)
      @name = name
      @allowed_ips = allowed_ips
    end
  end
end
