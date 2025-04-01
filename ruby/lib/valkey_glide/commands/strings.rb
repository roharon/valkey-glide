# frozen_string_literal: true

module ValkeyGlide
  module Commands
    # Strings module implements Redis string commands
    module Strings
      # Get the value of a key
      #
      # @example
      #   client.get("mykey")
      #
      # @param key [String] the key to get
      # @return [String, nil] the value of the key, or nil if the key does not exist
      def get(key)
        execute_command("GET", key)
      end

      # Set the value of a key
      #
      # @example Simple set
      #   client.set("mykey", "hello world")
      #
      # @example Set with expiration
      #   client.set("mykey", "hello world", ex: 10)
      #
      # @example Set with nx option (only if does not exist)
      #   client.set("mykey", "hello world", nx: true)
      #
      # @param key [String] the key to set
      # @param value [String] the value to set
      # @param ex [Integer] set the specified expire time, in seconds
      # @param px [Integer] set the specified expire time, in milliseconds
      # @param exat [Integer] set the specified Unix time at which the key will expire, in seconds
      # @param pxat [Integer] set the specified Unix time at which the key will expire, in milliseconds
      # @param nx [Boolean] only set the key if it does not already exist
      # @param xx [Boolean] only set the key if it already exists
      # @param keepttl [Boolean] retain the time to live associated with the key
      # @param get [Boolean] return the old value stored at key, or nil if key did not exist
      # @return [String, nil] the operation result
      def set(key, value, ex: nil, px: nil, exat: nil, pxat: nil, nx: nil, xx: nil, keepttl: nil, get: nil)
        args = [key, value]
        
        args << "EX" << ex.to_s if ex
        args << "PX" << px.to_s if px
        args << "EXAT" << exat.to_s if exat
        args << "PXAT" << pxat.to_s if pxat
        args << "NX" if nx
        args << "XX" if xx
        args << "KEEPTTL" if keepttl
        args << "GET" if get
        
        execute_command("SET", *args)
      end

      # Get the value of a key and delete the key
      #
      # @example
      #   client.getdel("mykey")
      #
      # @param key [String] the key to get and delete
      # @return [String, nil] the value of the key, or nil if the key does not exist
      def getdel(key)
        execute_command("GETDEL", key)
      end

      # Get the value of a key and optionally set its expiration
      #
      # @example Get and set expiration in seconds
      #   client.getex("mykey", ex: 10)
      #
      # @example Get and persist the key (remove expiration)
      #   client.getex("mykey", persist: true)
      #
      # @param key [String] the key to get
      # @param ex [Integer] set the specified expire time, in seconds
      # @param px [Integer] set the specified expire time, in milliseconds
      # @param exat [Integer] set the specified Unix time at which the key will expire, in seconds
      # @param pxat [Integer] set the specified Unix time at which the key will expire, in milliseconds
      # @param persist [Boolean] remove the time to live associated with the key
      # @return [String, nil] the value of the key, or nil if the key does not exist
      def getex(key, ex: nil, px: nil, exat: nil, pxat: nil, persist: nil)
        args = [key]
        
        args << "EX" << ex.to_s if ex
        args << "PX" << px.to_s if px
        args << "EXAT" << exat.to_s if exat
        args << "PXAT" << pxat.to_s if pxat
        args << "PERSIST" if persist
        
        execute_command("GETEX", *args)
      end

      # Get a substring of a string stored at a key
      #
      # @example Get first 5 characters
      #   client.getrange("mykey", 0, 4)
      #
      # @example Get last 5 characters
      #   client.getrange("mykey", -5, -1)
      #
      # @param key [String] the key to get the substring from
      # @param start [Integer] the start position
      # @param end [Integer] the end position
      # @return [String] the substring
      def getrange(key, start, end_pos)
        execute_command("GETRANGE", key, start.to_s, end_pos.to_s)
      end

      # Get the length of a string value
      #
      # @example
      #   client.strlen("mykey")
      #
      # @param key [String] the key to get the length of
      # @return [Integer] the length of the string at key, or 0 if the key does not exist
      def strlen(key)
        execute_command("STRLEN", key)
      end

      # Append a value to a key
      #
      # @example
      #   client.append("mykey", " world")
      #
      # @param key [String] the key to append to
      # @param value [String] the value to append
      # @return [Integer] the length of the string after the append operation
      def append(key, value)
        execute_command("APPEND", key, value)
      end

      # Set multiple keys to multiple values
      #
      # @example
      #   client.mset(key1: "value1", key2: "value2")
      #
      # @param hash [Hash] the key-value pairs to set
      # @return [String] "OK"
      def mset(hash)
        args = []
        hash.each do |k, v|
          args.push(k.to_s, v.to_s)
        end
        execute_command("MSET", *args)
      end

      # Set multiple keys to multiple values, only if none of the keys exist
      #
      # @example
      #   client.msetnx(key1: "value1", key2: "value2")
      #
      # @param hash [Hash] the key-value pairs to set
      # @return [Boolean] true if all keys were set, false if no key was set
      def msetnx(hash)
        args = []
        hash.each do |k, v|
          args.push(k.to_s, v.to_s)
        end
        execute_command("MSETNX", *args)
      end

      # Get the values of multiple keys
      #
      # @example
      #   client.mget("key1", "key2", "key3")
      #
      # @param keys [Array<String>] the keys to get
      # @return [Array<String, nil>] the values of the keys, or nil for keys that do not exist
      def mget(*keys)
        execute_command("MGET", *keys)
      end

      # Increment the integer value of a key by one
      #
      # @example
      #   client.incr("counter")
      #
      # @param key [String] the key to increment
      # @return [Integer] the value of the key after the increment
      def incr(key)
        execute_command("INCR", key)
      end

      # Increment the integer value of a key by the given amount
      #
      # @example
      #   client.incrby("counter", 5)
      #
      # @param key [String] the key to increment
      # @param increment [Integer] the amount to increment by
      # @return [Integer] the value of the key after the increment
      def incrby(key, increment)
        execute_command("INCRBY", key, increment.to_s)
      end

      # Increment the float value of a key by the given amount
      #
      # @example
      #   client.incrbyfloat("counter", 1.5)
      #
      # @param key [String] the key to increment
      # @param increment [Float] the amount to increment by
      # @return [Float] the value of the key after the increment
      def incrbyfloat(key, increment)
        execute_command("INCRBYFLOAT", key, increment.to_s)
      end

      # Decrement the integer value of a key by one
      #
      # @example
      #   client.decr("counter")
      #
      # @param key [String] the key to decrement
      # @return [Integer] the value of the key after the decrement
      def decr(key)
        execute_command("DECR", key)
      end

      # Decrement the integer value of a key by the given amount
      #
      # @example
      #   client.decrby("counter", 5)
      #
      # @param key [String] the key to decrement
      # @param decrement [Integer] the amount to decrement by
      # @return [Integer] the value of the key after the decrement
      def decrby(key, decrement)
        execute_command("DECRBY", key, decrement.to_s)
      end

      # Overwrite part of a string at a key starting at the specified offset
      #
      # @example
      #   client.setrange("key", 6, "redis")
      #
      # @param key [String] the key to modify
      # @param offset [Integer] the offset to start at
      # @param value [String] the value to write at the offset
      # @return [Integer] the length of the string after the operation
      def setrange(key, offset, value)
        execute_command("SETRANGE", key, offset.to_s, value)
      end
    end
  end
end
