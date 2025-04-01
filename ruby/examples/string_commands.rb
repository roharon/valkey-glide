#!/usr/bin/env ruby
# frozen_string_literal: true

require "valkey_glide"

# Create a new Valkey client
client = ValkeyGlide::Client.new

begin
  # Clear database
  client.flushdb
  
  puts "=== Basic String Operations ==="
  
  # SET and GET
  client.set("mykey", "Hello Valkey")
  puts "SET and GET: #{client.get('mykey')}"
  
  # SET with expiration
  client.set("expiring_key", "I expire in 10 seconds", ex: 10)
  puts "SET with expiration: #{client.get('expiring_key')}"
  puts "TTL: #{client.ttl('expiring_key')} seconds"
  
  # SET with NX option (only if not exists)
  result = client.set("newkey", "This is new", nx: true)
  puts "SET with NX (new key): #{result}"
  
  result = client.set("newkey", "This won't be set", nx: true)
  puts "SET with NX (existing key): #{result.inspect}"
  puts "Value remains: #{client.get('newkey')}"
  
  # SET with XX option (only if exists)
  result = client.set("mykey", "Updated value", xx: true)
  puts "SET with XX (existing key): #{result}"
  puts "Updated value: #{client.get('mykey')}"
  
  result = client.set("nonexistent", "This won't be set", xx: true)
  puts "SET with XX (non-existent key): #{result.inspect}"
  
  # SET with GET option (return old value)
  client.set("getkey", "Original value")
  old_value = client.set("getkey", "New value", get: true)
  puts "Old value: #{old_value}"
  puts "New value: #{client.get('getkey')}"
  
  # GETRANGE - Substring of a value
  client.set("message", "Hello Valkey")
  puts "\n=== Substring Operations ==="
  puts "Full message: #{client.get('message')}"
  puts "First 5 chars: #{client.getrange('message', 0, 4)}"
  puts "Last 6 chars: #{client.getrange('message', -6, -1)}"
  
  # STRLEN - String length
  puts "String length: #{client.strlen('message')} bytes"
  
  # APPEND - Append value to string
  client.set("greeting", "Hello")
  length = client.append("greeting", " Valkey!")
  puts "\n=== Append Operation ==="
  puts "Appended string length: #{length}"
  puts "New value: #{client.get('greeting')}"
  
  # SETRANGE - Overwrite part of string
  client.set("overwrite", "Hello World")
  length = client.setrange("overwrite", 6, "Valkey")
  puts "\n=== Overwrite Operation ==="
  puts "Modified string length: #{length}"
  puts "New value: #{client.get('overwrite')}"
  
  # MSET and MGET - Multiple operations
  puts "\n=== Multiple Key Operations ==="
  client.mset(key1: "value1", key2: "value2", key3: "value3")
  values = client.mget("key1", "key2", "key3", "nonexistent")
  puts "Multiple values: #{values.inspect}"
  
  # MSETNX - Set multiple only if none exist
  result = client.msetnx(newkey1: "value1", newkey2: "value2")
  puts "MSETNX (all new): #{result}"
  
  result = client.msetnx(newkey1: "new value", key1: "won't set")
  puts "MSETNX (some exist): #{result}"
  
  # GETDEL - Get and delete
  client.set("temp", "Temporary value")
  value = client.getdel("temp")
  puts "\n=== Get and Delete ==="
  puts "Value before delete: #{value}"
  puts "Value after delete: #{client.get('temp').inspect}"
  
  # Increment/Decrement operations
  puts "\n=== Numeric Operations ==="
  client.set("counter", "10")
  puts "Counter initial value: #{client.get('counter')}"
  puts "INCR: #{client.incr('counter')}"
  puts "INCRBY 5: #{client.incrby('counter', 5)}"
  puts "DECR: #{client.decr('counter')}"
  puts "DECRBY 2: #{client.decrby('counter', 2)}"
  
  # Float increment
  client.set("pi", "3.0")
  puts "INCRBYFLOAT: #{client.incrbyfloat('pi', 0.14159)}"
  
rescue => e
  puts "Error: #{e.message}"
  puts e.backtrace.join("\n")
ensure
  client.close
  puts "\nConnection closed."
end
