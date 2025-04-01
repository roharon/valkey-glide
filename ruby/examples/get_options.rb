#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'valkey_glide'

# Create a new client
client = ValkeyGlide.client(
  host: 'localhost',
  port: 6379
)

begin
  client.flushdb

  puts "=== Basic GET operation ==="
  client.set("key1", "Hello World")
  puts "Value of key1: #{client.get("key1")}"

  puts "\n=== GETEX with Hash options ==="
  client.set("key2", "Expires in 10 seconds")
  value = client.getex("key2", ex: 10)
  puts "Value of key2: #{value}"
  puts "TTL of key2: #{client.ttl("key2")} seconds"

  puts "\n=== GETEX with options builder ==="
  client.set("key3", "Using options builder")

  # Create options using builder pattern
  options = ValkeyGlide::Options.getex do |opt|
    opt.ex(20)
  end

  value = client.getex("key3", options)
  puts "Value of key3: #{value}"
  puts "TTL of key3: #{client.ttl("key3")} seconds"

  puts "\n=== SET with options builder ==="
  # Create options using builder pattern
  set_options = ValkeyGlide::Options.set do |opt|
    opt.ex(30).nx
  end

  # Try to set with NX (only if not exists)
  result = client.set("key4", "New key with options", set_options)
  puts "Setting new key4: #{result}"
  puts "Value of key4: #{client.get("key4")}"

  # Try again with NX - should not set
  result = client.set("key4", "Trying to override", set_options)
  puts "Trying to override key4: #{result.inspect}"
  puts "Value of key4 after override attempt: #{client.get("key4")}"

  puts "\n=== SET with GET option ==="
  # Set with GET option to return the old value
  client.set("key5", "Original value")

  get_option = ValkeyGlide::Options.set do |opt|
    opt.get
  end

  old_value = client.set("key5", "New value", get_option)
  puts "Old value of key5: #{old_value}"
  puts "New value of key5: #{client.get("key5")}"

rescue => e
  puts "Error: #{e.message}"
  puts e.backtrace
ensure
  client.close
  puts "\nClient closed"
end
