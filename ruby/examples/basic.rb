#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'valkey_glide'

# Create a new client
client = ValkeyGlide.client(
  host: 'localhost',
  port: 6379
)

# Test basic operations
begin
  puts "Ping: #{client.ping}"
  
  puts "Setting key 'hello'"
  client.set('hello', 'world')
  
  puts "Getting key 'hello': #{client.get('hello')}"
  
  puts "Setting key 'counter' to 1"
  client.set('counter', '1')
  
  puts "Getting info about server: #{client.info}"
  
  puts "Closing client"
  client.close
rescue => e
  puts "Error: #{e.message}"
  puts e.backtrace
ensure
  client.close if client
end
