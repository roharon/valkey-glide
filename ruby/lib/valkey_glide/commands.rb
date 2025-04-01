# frozen_string_literal: true

require_relative "commands/strings"
require_relative "commands/keys"
require_relative "commands/server"

module ValkeyGlide
  module Commands
    # Include all command modules
    def self.included(base)
      base.include Strings
      base.include Keys
      base.include Server
    end
  end
end
