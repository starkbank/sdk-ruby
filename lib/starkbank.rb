# frozen_string_literal: true

require_relative('key')
require_relative('user/project')

# SDK to facilitate Ruby integrations with Stark Bank
module StarkBank
  @user = nil
  class << self; attr_accessor :user; end
end
