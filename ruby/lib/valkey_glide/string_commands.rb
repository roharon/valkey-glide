# frozen_string_literal: true

module ValkeyGlide
  # StringCommands module provides methods for working with string values in Valkey
  module StringCommands
    # Get string value associated with the given key
    #
    # @param key [String] The key to retrieve
    #
    # @return [String, nil] Value of the key as a string, or nil if key does not exist
    # @raise [Error] If an error occurs during the operation
    def get(key)
      _execute_command(@client_ptr, "GET", [key])
    end

    # Get string value associated with the given key and optionally set its expiration
    #
    # @param key [String] The key to retrieve
    # @param options [Hash, Options::GetExOptions] Expiration options
    # @option options [Integer] :ex Set the specified expire time, in seconds
    # @option options [Integer] :px Set the specified expire time, in milliseconds
    # @option options [Integer] :exat Set the specified Unix time at which the key will expire, in seconds
    # @option options [Integer] :pxat Set the specified Unix time at which the key will expire, in milliseconds
    # @option options [Boolean] :persist Remove the time to live associated with the key
    #
    # @return [String, nil] Value of the key as a string, or nil if key does not exist
    # @raise [Error] If an error occurs during the operation
    def getex(key, options = {})
      args = [key]
      
      if options.is_a?(Options::GetExOptions)
        args.concat(options.to_args)
      else
        if options[:ex]
          args << "EX" << options[:ex].to_s
        elsif options[:px]
          args << "PX" << options[:px].to_s
        elsif options[:exat]
          args << "EXAT" << options[:exat].to_s
        elsif options[:pxat]
          args << "PXAT" << options[:pxat].to_s
        elsif options[:persist]
          args << "PERSIST"
        end
      end
      
      _execute_command(@client_ptr, "GETEX", args)
    end
    
    # Removes and returns the value associated with the given key
    #
    # @param key [String] The key to retrieve and delete
    #
    # @return [String, nil] Value of the key as a string, or nil if key does not exist
    # @raise [Error] If an error occurs during the operation
    def getdel(key)
      _execute_command(@client_ptr, "GETDEL", [key])
    end
    
    # Returns the substring of the string value stored at key, determined by the offsets start and end
    #
    # @param key [String] The key of the string
    # @param start [Integer] The starting offset
    # @param stop [Integer] The ending offset
    #
    # @return [String] The substring extracted from the value stored at key
    # @raise [Error] If an error occurs during the operation
    def getrange(key, start, stop)
      _execute_command(@client_ptr, "GETRANGE", [key, start.to_s, stop.to_s])
    end
    
    # Returns the length of the string value stored at key
    #
    # @param key [String] The key to check length
    #
    # @return [Integer] The length of the string at key, or 0 if key does not exist
    # @raise [Error] If an error occurs during the operation
    def strlen(key)
      _execute_command(@client_ptr, "STRLEN", [key])
    end

    # Append a value to a key
    #
    # @param key [String] The key to append to
    # @param value [String] The value to append
    #
    # @return [Integer] The length of the string after the append operation
    # @raise [Error] If an error occurs during the operation
    def append(key, value)
      _execute_command(@client_ptr, "APPEND", [key, value])
    end

    # Set the string value of a key
    #
    # @param key [String] The key to set
    # @param value [String] The value to set
    # @param options [Hash, Options::SetOptions] Additional options
    # 
    # @return [String, nil] The value returned depends on the options specified
    # @raise [Error] If an error occurs during the operation
    def set(key, value, options = {})
      args = [key, value]
      
      if options.is_a?(Options::SetOptions)
        args.concat(options.to_args)
      else
        if options[:ex]
          args << "EX" << options[:ex].to_s
        elsif options[:px]
          args << "PX" << options[:px].to_s
        elsif options[:exat]
          args << "EXAT" << options[:exat].to_s
        elsif options[:pxat]
          args << "PXAT" << options[:pxat].to_s
        end
        
        args << "NX" if options[:nx]
        args << "XX" if options[:xx]
        args << "KEEPTTL" if options[:keepttl]
        args << "GET" if options[:get]
      end
      
      _execute_command(@client_ptr, "SET", args)
    end

    # Set the value of a key, only if the key does not exist
    #
    # @param key [String] The key to set
    # @param value [String] The value to set
    #
    # @return [Boolean] true if the key was set, false if the key was not set
    # @raise [Error] If an error occurs during the operation
    def setnx(key, value)
      _execute_command(@client_ptr, "SETNX", [key, value])
    end

    # Sets the given keys to their respective values
    #
    # @param hash [Hash] Hash of key-value pairs to set
    #
    # @return [String] "OK"
    # @raise [Error] If an error occurs during the operation
    def mset(hash)
      args = []
      hash.each do |k, v|
        args << k.to_s << v.to_s
      end
      _execute_command(@client_ptr, "MSET", args)
    end

    # Sets the given keys to their respective values, only if none of the keys exist
    #
    # @param hash [Hash] Hash of key-value pairs to set
    #
    # @return [Boolean] true if all keys were set, false if no key was set
    # @raise [Error] If an error occurs during the operation
    def msetnx(hash)
      args = []
      hash.each do |k, v|
        args << k.to_s << v.to_s
      end
      _execute_command(@client_ptr, "MSETNX", args)
    end

    # Get the values of all the given keys
    #
    # @param keys [Array<String>] The keys to get
    #
    # @return [Array<String, nil>] Array of values, nil for keys that do not exist
    # @raise [Error] If an error occurs during the operation
    def mget(*keys)
      _execute_command(@client_ptr, "MGET", keys)
    end
  end
end
