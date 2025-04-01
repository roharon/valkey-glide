# frozen_string_literal: true

module ValkeyGlide
  # Base error class for all Valkey errors
  class Error < StandardError; end
  
  # Raised when a connection to the server cannot be established
  class ConnectionError < Error; end
  
  # Raised when authentication fails
  class AuthError < Error; end
  
  # Raised when a command fails to execute
  class CommandError < Error; end
  
  # Raised when a command times out
  class TimeoutError < Error; end
  
  # Raised when an operation is performed on a key of the wrong type
  class TypeError < Error; end
  
  # Raised when a key does not exist
  class KeyError < Error; end
  
  # Raised when a syntax error occurs
  class SyntaxError < Error; end
end
