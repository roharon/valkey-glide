# frozen_string_literal: true

require_relative 'options/string_options'

module ValkeyGlide
  # Options module provides option builders for various Valkey commands
  module Options
    # Create GetEx options
    #
    # @yield [options] Block to configure options
    # @yieldparam options [GetExOptions] Options builder
    # @return [GetExOptions] Configured options
    def self.getex
      options = GetExOptions.new
      yield options if block_given?
      options
    end
    
    # Create Set options
    #
    # @yield [options] Block to configure options
    # @yieldparam options [SetOptions] Options builder
    # @return [SetOptions] Configured options
    def self.set
      options = SetOptions.new
      yield options if block_given?
      options
    end
  end
end
