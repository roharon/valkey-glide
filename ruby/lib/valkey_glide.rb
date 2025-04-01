# frozen_string_literal: true

require_relative "valkey_glide/version"
require_relative "valkey_glide/valkey_glide" # Rust extension
require_relative "valkey_glide/errors"
require_relative "valkey_glide/commands"
require_relative "valkey_glide/client"

# ValkeyGlide is a Ruby client for Valkey database
#
# @example Basic usage
#   require "valkey_glide"
#
#   # Create a client
#   client = ValkeyGlide::Client.new(host: "localhost", port: 6379)
#
#   # Set a string value
#   client.set("mykey", "hello valkey")
#
#   # Get a string value
#   value = client.get("mykey")
#   puts value  # => "hello valkey"
#
#   # Close the connection
#   client.close
module ValkeyGlide
  # Creates a new client instance
  #
  # @param opts [Hash] connection options, see Client#initialize for details
  # @return [Client] a new client instance
  def self.new(opts = {})
    Client.new(opts)
  end
end
