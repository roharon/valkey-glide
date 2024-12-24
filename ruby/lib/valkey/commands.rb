# frozen_string_literal: true

require "valkey/commands/strings"

class Valkey
  module Commands
    include Strings
  end
end
