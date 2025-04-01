# frozen_string_literal: true

require_relative "commands"
require_relative "errors"

module ValkeyGlide
  # Client class for connecting to Valkey server
  # This class provides a Ruby interface to the Valkey database
  class Client
    include Commands
    
    # Creates a new client instance
    #
    # @param opts [Hash] connection options
    # @option opts [String] :host ("127.0.0.1") Server hostname or IP
    # @option opts [Integer] :port (6379) Server port
    # @option opts [String] :username Username for authentication
    # @option opts [String] :password Password for authentication
    # @option opts [Integer] :db (0) Database number
    #
    # @example Connect to default server
    #   client = ValkeyGlide::Client.new
    #
    # @example Connect with custom options
    #   client = ValkeyGlide::Client.new(
    #     host: "valkey.example.com",
    #     port: 6380,
    #     password: "secret",
    #     db: 1
    #   )
    #
    # @return [Client] a new client instance
    def initialize(opts = {})
      @options = {
        host: "127.0.0.1",
        port: 6379,
        db: 0
      }.merge(opts)
      
      @client = self.class._create_client(@options)
    end
    
    # Closes the connection to the server
    #
    # @return [Boolean] true if disconnected
    def close
      _close_client
      true
    end
    
    # Executes a command on the server
    #
    # @param command [String] the command to execute
    # @param args [Array<String>] command arguments
    # @return [Object] the command result
    # @raise [Error] if the command fails
    def execute_command(command, *args)
      # Convert all arguments to strings
      args = args.map(&:to_s)
      
      begin
        _execute_command(command.to_s.upcase, args)
      rescue => e
        handle_error(e)
      end
    end
    
    private
    
    # Handles errors raised during command execution
    #
    # @param error [Exception] the error to handle
    # @raise [Error] the appropriate error type
    def handle_error(error)
      case error.message
      when /WRONGTYPE/
        raise TypeError, error.message
      when /NOAUTH/
        raise AuthError, error.message
      when /timeout/i
        raise TimeoutError, error.message
      when /connection/i
        raise ConnectionError, error.message
      else
        raise CommandError, error.message
      end
    end
  end
end
