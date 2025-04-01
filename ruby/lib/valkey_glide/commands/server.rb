# frozen_string_literal: true

module ValkeyGlide
  module Commands
    # Server module implements Redis server commands
    module Server
      # Get information and statistics about the server
      #
      # @example Get all information
      #   client.info
      #
      # @example Get specific section
      #   client.info("memory")
      #
      # @param sections [Array<String>] the sections to get information about
      # @return [String] the server information
      def info(*sections)
        execute_command("INFO", *sections)
      end

      # Ping the server
      #
      # @example Simple ping
      #   client.ping
      #
      # @example Ping with message
      #   client.ping("hello")
      #
      # @param message [String, nil] the message to ping with
      # @return [String] "PONG" if no message is provided, otherwise the message
      def ping(message = nil)
        args = message.nil? ? [] : [message]
        execute_command("PING", *args)
      end

      # Select the Redis logical database
      #
      # @example Select database 1
      #   client.select(1)
      #
      # @param index [Integer] the database index
      # @return [String] "OK"
      def select(index)
        execute_command("SELECT", index.to_s)
      end

      # Get the number of keys in the current database
      #
      # @example
      #   client.dbsize
      #
      # @return [Integer] the number of keys in the current database
      def dbsize
        execute_command("DBSIZE")
      end

      # Remove all keys from all databases
      #
      # @example Synchronous flush
      #   client.flushall
      #
      # @example Asynchronous flush
      #   client.flushall(async: true)
      #
      # @param async [Boolean] whether to flush asynchronously
      # @return [String] "OK"
      def flushall(async: nil)
        args = async ? ["ASYNC"] : []
        execute_command("FLUSHALL", *args)
      end

      # Remove all keys from the current database
      #
      # @example Synchronous flush
      #   client.flushdb
      #
      # @example Asynchronous flush
      #   client.flushdb(async: true)
      #
      # @param async [Boolean] whether to flush asynchronously
      # @return [String] "OK"
      def flushdb(async: nil)
        args = async ? ["ASYNC"] : []
        execute_command("FLUSHDB", *args)
      end

      # Get the server time
      #
      # @example
      #   client.time
      #
      # @return [Array<String>] a two-element array of strings: Unix timestamp and microseconds
      def time
        execute_command("TIME")
      end

      # Get the current connection ID
      #
      # @example
      #   client.client_id
      #
      # @return [Integer] the client ID
      def client_id
        execute_command("CLIENT", "ID")
      end

      # Set the current connection name
      #
      # @example
      #   client.client_setname("my-connection")
      #
      # @param name [String] the connection name
      # @return [String] "OK"
      def client_setname(name)
        execute_command("CLIENT", "SETNAME", name)
      end

      # Get the current connection name
      #
      # @example
      #   client.client_getname
      #
      # @return [String, nil] the connection name, or nil if no name is set
      def client_getname
        execute_command("CLIENT", "GETNAME")
      end

      # Kill a client by ID or matching conditions
      #
      # @example Kill a client by ID
      #   client.client_kill(id: 123)
      #
      # @example Kill a client by address
      #   client.client_kill(addr: "127.0.0.1:12345")
      #
      # @example Kill a client by type and skipme
      #   client.client_kill(type: "normal", skipme: true)
      #
      # @param id [Integer] the client ID
      # @param addr [String] the client address
      # @param type [String] the client type ("normal", "master", "slave", "pubsub")
      # @param skipme [Boolean] whether to skip the calling client
      # @return [String, Integer] "OK" or the number of clients killed
      def client_kill(id: nil, addr: nil, type: nil, skipme: nil)
        args = []
        args.push("ID", id.to_s) if id
        args.push("ADDR", addr) if addr
        args.push("TYPE", type) if type
        args.push("SKIPME", skipme ? "yes" : "no") if skipme
        execute_command("CLIENT", "KILL", *args)
      end

      # Get the list of client connections
      #
      # @example
      #   client.client_list
      #
      # @param type [String] the type of clients to list
      # @param client_id [Array<Integer>] list of client IDs to get
      # @return [String] formatted string of client information
      def client_list(type: nil, client_id: nil)
        args = []
        args.push("TYPE", type) if type
        if client_id
          args.push("ID")
          Array(client_id).each { |id| args.push(id.to_s) }
        end
        execute_command("CLIENT", "LIST", *args)
      end

      # Execute a command on all Valkey Cluster nodes
      #
      # @example Ping all nodes
      #   client.cluster_command("PING")
      #
      # @param command [String] the command to execute
      # @param args [Array<String>] the command arguments
      # @return [Array<String>] the command results
      def cluster_command(command, *args)
        execute_command("CLUSTER", command, *args)
      end
    end
  end
end
