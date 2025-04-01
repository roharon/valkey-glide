# frozen_string_literal: true

module ValkeyGlide
  module Commands
    module Keys
      # Delete keys
      #
      # @example Delete a single key
      #   client.del("key1")
      #
      # @example Delete multiple keys
      #   client.del("key1", "key2", "key3")
      #
      # @param keys [Array<String>] the keys to delete
      # @return [Integer] the number of keys that were deleted
      def del(*keys)
        execute_command("DEL", *keys)
      end

      # Determine if a key exists
      #
      # @example Check a single key
      #   client.exists("key1")
      #
      # @example Check multiple keys
      #   client.exists("key1", "key2", "key3")
      #
      # @param keys [Array<String>] the keys to check
      # @return [Integer] the number of keys that exist
      def exists(*keys)
        execute_command("EXISTS", *keys)
      end

      # Set a key's time to live in seconds
      #
      # @example Set a key to expire in 10 seconds
      #   client.expire("key", 10)
      #
      # @example Set a key to expire only if it has no expiry
      #   client.expire("key", 10, nx: true)
      #
      # @param key [String] the key to set the expiration for
      # @param seconds [Integer] the number of seconds
      # @param nx [Boolean] only set expiry when the key has no expiry
      # @param xx [Boolean] only set expiry when the key has an existing expiry
      # @param gt [Boolean] only set expiry when new expiry is greater than current expiry
      # @param lt [Boolean] only set expiry when new expiry is less than current expiry
      # @return [Boolean] true if the timeout was set, false otherwise
      def expire(key, seconds, nx: nil, xx: nil, gt: nil, lt: nil)
        args = [key, seconds.to_s]
        args << "NX" if nx
        args << "XX" if xx
        args << "GT" if gt
        args << "LT" if lt
        execute_command("EXPIRE", *args)
      end

      # Set a key's time to live in milliseconds
      #
      # @example Set a key to expire in 10000 milliseconds
      #   client.pexpire("key", 10000)
      #
      # @param key [String] the key to set the expiration for
      # @param milliseconds [Integer] the number of milliseconds
      # @param nx [Boolean] only set expiry when the key has no expiry
      # @param xx [Boolean] only set expiry when the key has an existing expiry
      # @param gt [Boolean] only set expiry when new expiry is greater than current expiry
      # @param lt [Boolean] only set expiry when new expiry is less than current expiry
      # @return [Boolean] true if the timeout was set, false otherwise
      def pexpire(key, milliseconds, nx: nil, xx: nil, gt: nil, lt: nil)
        args = [key, milliseconds.to_s]
        args << "NX" if nx
        args << "XX" if xx
        args << "GT" if gt
        args << "LT" if lt
        execute_command("PEXPIRE", *args)
      end

      # Set the expiration for a key as a UNIX timestamp in seconds
      #
      # @example Set a key to expire at a specific Unix timestamp
      #   client.expireat("key", 1609459200)
      #
      # @param key [String] the key to set the expiration for
      # @param unix_time [Integer] the Unix timestamp in seconds
      # @param nx [Boolean] only set expiry when the key has no expiry
      # @param xx [Boolean] only set expiry when the key has an existing expiry
      # @param gt [Boolean] only set expiry when new expiry is greater than current expiry
      # @param lt [Boolean] only set expiry when new expiry is less than current expiry
      # @return [Boolean] true if the timeout was set, false otherwise
      def expireat(key, unix_time, nx: nil, xx: nil, gt: nil, lt: nil)
        args = [key, unix_time.to_s]
        args << "NX" if nx
        args << "XX" if xx
        args << "GT" if gt
        args << "LT" if lt
        execute_command("EXPIREAT", *args)
      end

      # Set the expiration for a key as a UNIX timestamp in milliseconds
      #
      # @example Set a key to expire at a specific Unix timestamp in milliseconds
      #   client.pexpireat("key", 1609459200000)
      #
      # @param key [String] the key to set the expiration for
      # @param unix_time_ms [Integer] the Unix timestamp in milliseconds
      # @param nx [Boolean] only set expiry when the key has no expiry
      # @param xx [Boolean] only set expiry when the key has an existing expiry
      # @param gt [Boolean] only set expiry when new expiry is greater than current expiry
      # @param lt [Boolean] only set expiry when new expiry is less than current expiry
      # @return [Boolean] true if the timeout was set, false otherwise
      def pexpireat(key, unix_time_ms, nx: nil, xx: nil, gt: nil, lt: nil)
        args = [key, unix_time_ms.to_s]
        args << "NX" if nx
        args << "XX" if xx
        args << "GT" if gt
        args << "LT" if lt
        execute_command("PEXPIREAT", *args)
      end

      # Get the time to live for a key in seconds
      #
      # @example
      #   client.ttl("key")
      #
      # @param key [String] the key to get the time to live for
      # @return [Integer] TTL in seconds, -2 if key doesn't exist, -1 if key exists but has no TTL
      def ttl(key)
        execute_command("TTL", key)
      end

      # Get the time to live for a key in milliseconds
      #
      # @example
      #   client.pttl("key")
      #
      # @param key [String] the key to get the time to live for
      # @return [Integer] TTL in milliseconds, -2 if key doesn't exist, -1 if key exists but has no TTL
      def pttl(key)
        execute_command("PTTL", key)
      end

      # Get the expiration Unix timestamp of a key in seconds
      #
      # @example
      #   client.expiretime("key")
      #
      # @param key [String] the key to get the expiration time for
      # @return [Integer] Unix timestamp in seconds, -2 if key doesn't exist, -1 if key exists but has no TTL
      def expiretime(key)
        execute_command("EXPIRETIME", key)
      end

      # Get the expiration Unix timestamp of a key in milliseconds
      #
      # @example
      #   client.pexpiretime("key")
      #
      # @param key [String] the key to get the expiration time for
      # @return [Integer] Unix timestamp in milliseconds, -2 if key doesn't exist, -1 if key exists but has no TTL
      def pexpiretime(key)
        execute_command("PEXPIRETIME", key)
      end

      # Remove the expiration from a key
      #
      # @example
      #   client.persist("key")
      #
      # @param key [String] the key to remove the expiration from
      # @return [Boolean] true if the timeout was removed, false if key doesn't exist or has no timeout
      def persist(key)
        execute_command("PERSIST", key)
      end

      # Return a random key from the keyspace
      #
      # @example
      #   client.randomkey
      #
      # @return [String, nil] a random key, or nil if the database is empty
      def randomkey
        execute_command("RANDOMKEY")
      end

      # Rename a key
      #
      # @example
      #   client.rename("old_key", "new_key")
      #
      # @param key [String] the key to rename
      # @param newkey [String] the new name for the key
      # @return [String] "OK"
      # @raise [Error] if key does not exist
      def rename(key, newkey)
        execute_command("RENAME", key, newkey)
      end

      # Rename a key, only if the new key does not exist
      #
      # @example
      #   client.renamenx("old_key", "new_key")
      #
      # @param key [String] the key to rename
      # @param newkey [String] the new name for the key
      # @return [Boolean] true if key was renamed, false if newkey already exists
      def renamenx(key, newkey)
        execute_command("RENAMENX", key, newkey)
      end

      # Create a key using the provided REdis Serialization Protocol (RESP) value
      #
      # @example Create a simple string
      #   client.restore("key", 0, "\x00\x05hello", replace: true)
      #
      # @param key [String] the key to create
      # @param ttl [Integer] the time to live in milliseconds
      # @param serialized_value [String] the serialized value
      # @param replace [Boolean] whether to replace an existing key
      # @param absttl [Boolean] whether to use an absolute Unix timestamp for ttl
      # @param idletime [Integer] the idle time in seconds for the key
      # @param freq [Integer] the frequency for the key
      # @return [String] "OK"
      def restore(key, ttl, serialized_value, replace: nil, absttl: nil, idletime: nil, freq: nil)
        args = [key, ttl.to_s, serialized_value]
        args << "REPLACE" if replace
        args << "ABSTTL" if absttl
        args << "IDLETIME" << idletime.to_s if idletime
        args << "FREQ" << freq.to_s if freq
        execute_command("RESTORE", *args)
      end

      # Increment the Valkey Keyspace notification configuration
      #
      # @example Enable keyspace notifications for all keys
      #   client.config_set("notify-keyspace-events", "AKE")
      #
      # @param parameter [String] the configuration parameter
      # @param value [String] the value to set
      # @return [String] "OK"
      def config_set(parameter, value)
        execute_command("CONFIG", "SET", parameter, value)
      end

      # Get Valkey configuration
      #
      # @example Get keyspace notification configuration
      #   client.config_get("notify-keyspace-events")
      #
      # @param parameter [String] the configuration parameter
      # @return [Hash] a hash of configuration parameters and values
      def config_get(parameter)
        execute_command("CONFIG", "GET", parameter)
      end

      # Move a key to another database
      #
      # @example Move a key to database 1
      #   client.move("key", 1)
      #
      # @param key [String] the key to move
      # @param db [Integer] the destination database index
      # @return [Boolean] true if key was moved, false if key was not moved
      def move(key, db)
        execute_command("MOVE", key, db.to_s)
      end
    end
  end
end
