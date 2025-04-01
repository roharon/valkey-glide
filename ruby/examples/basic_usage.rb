# frozen_string_literal: true

require "valkey_glide"

# Create a new client
client = ValkeyGlide.new(
  host: "localhost", 
  port: 6379
)

# Set a key-value pair
client.set("hello", "world")
puts "Set 'hello' to 'world'"

# Get the value of a key
value = client.get("hello")
puts "Value of 'hello': #{value}"

# Try other commands
client.set("counter", 0)
client.incr("counter")
client.incr("counter")
puts "Counter value: #{client.get('counter')}"

# List some commands
client.lpush("mylist", ["first", "second", "third"])
puts "List length: #{client.llen('mylist')}"
puts "List items: #{client.lrange('mylist', 0, -1).inspect}"

# Close the connection
client.close
puts "Connection closed"
