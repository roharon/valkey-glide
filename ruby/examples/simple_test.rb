#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'valkey_glide'

puts "Creating Valkey client..."
client = ValkeyGlide::Client.new(
  host: 'localhost',
  port: 6379
)

begin
  puts "Testing commands..."
  
  # Test PING
  puts "PING: #{client.ping}"
  
  # Test SET
  puts "SET test_key 'hello': #{client.set('test_key', 'hello')}"
  
  # Test GET
  puts "GET test_key: #{client.get('test_key')}"
  
  # Test INFO
  puts "INFO: #{client.info.slice(0, 50)}..."
  
  # Test other commands
  puts "DEL test_key: #{client.del('test_key')}"
  puts "EXISTS test_key: #{client.exists('test_key')}"
  
  puts "All tests passed!"
rescue => e
  puts "Error: #{e.message}"
  puts e.backtrace
ensure
  puts "Closing client..."
  client.close
end
