# frozen_string_literal: true

module ValkeyGlide
  module Options
    # Option builder for GET commands
    class GetExOptions
      attr_reader :options
      
      def initialize
        @options = {}
      end
      
      # Set the specified expire time, in seconds
      # 
      # @param seconds [Integer] Expiry time in seconds
      # @return [GetExOptions] Self for chaining
      def ex(seconds)
        @options[:ex] = seconds
        self
      end
      
      # Set the specified expire time, in milliseconds
      #
      # @param milliseconds [Integer] Expiry time in milliseconds
      # @return [GetExOptions] Self for chaining
      def px(milliseconds)
        @options[:px] = milliseconds
        self
      end
      
      # Set the specified Unix time at which the key will expire, in seconds
      #
      # @param timestamp [Integer] Unix timestamp in seconds
      # @return [GetExOptions] Self for chaining
      def exat(timestamp)
        @options[:exat] = timestamp
        self
      end
      
      # Set the specified Unix time at which the key will expire, in milliseconds
      #
      # @param timestamp [Integer] Unix timestamp in milliseconds
      # @return [GetExOptions] Self for chaining 
      def pxat(timestamp)
        @options[:pxat] = timestamp
        self
      end
      
      # Remove the time to live associated with the key
      # 
      # @return [GetExOptions] Self for chaining
      def persist
        @options[:persist] = true
        self
      end
      
      # Convert the options to argument array
      #
      # @return [Array<String>] Array of Redis command arguments
      def to_args
        args = []
        
        if @options[:ex]
          args << "EX" << @options[:ex].to_s
        elsif @options[:px]
          args << "PX" << @options[:px].to_s
        elsif @options[:exat]
          args << "EXAT" << @options[:exat].to_s
        elsif @options[:pxat]
          args << "PXAT" << @options[:pxat].to_s
        elsif @options[:persist]
          args << "PERSIST"
        end
        
        args
      end
    end
    
    # Option builder for SET commands
    class SetOptions
      attr_reader :options
      
      def initialize
        @options = {}
      end
      
      # Set the specified expire time, in seconds
      # 
      # @param seconds [Integer] Expiry time in seconds
      # @return [SetOptions] Self for chaining
      def ex(seconds)
        @options[:ex] = seconds
        self
      end
      
      # Set the specified expire time, in milliseconds
      #
      # @param milliseconds [Integer] Expiry time in milliseconds
      # @return [SetOptions] Self for chaining
      def px(milliseconds)
        @options[:px] = milliseconds
        self
      end
      
      # Set the specified Unix time at which the key will expire, in seconds
      #
      # @param timestamp [Integer] Unix timestamp in seconds
      # @return [SetOptions] Self for chaining
      def exat(timestamp)
        @options[:exat] = timestamp
        self
      end
      
      # Set the specified Unix time at which the key will expire, in milliseconds
      #
      # @param timestamp [Integer] Unix timestamp in milliseconds
      # @return [SetOptions] Self for chaining 
      def pxat(timestamp)
        @options[:pxat] = timestamp
        self
      end
      
      # Only set the key if it does not already exist
      # 
      # @return [SetOptions] Self for chaining
      def nx
        @options[:nx] = true
        self
      end
      
      # Only set the key if it already exists
      # 
      # @return [SetOptions] Self for chaining
      def xx
        @options[:xx] = true
        self
      end
      
      # Retain the time to live associated with the key
      # 
      # @return [SetOptions] Self for chaining
      def keepttl
        @options[:keepttl] = true
        self
      end
      
      # Return the old value stored at key, or nil if key did not exist
      # 
      # @return [SetOptions] Self for chaining
      def get
        @options[:get] = true
        self
      end
      
      # Convert the options to argument array
      #
      # @return [Array<String>] Array of Redis command arguments
      def to_args
        args = []
        
        if @options[:ex]
          args << "EX" << @options[:ex].to_s
        elsif @options[:px]
          args << "PX" << @options[:px].to_s
        elsif @options[:exat]
          args << "EXAT" << @options[:exat].to_s
        elsif @options[:pxat]
          args << "PXAT" << @options[:pxat].to_s
        end
        
        args << "NX" if @options[:nx]
        args << "XX" if @options[:xx]
        args << "KEEPTTL" if @options[:keepttl]
        args << "GET" if @options[:get]
        
        args
      end
    end
  end
end
