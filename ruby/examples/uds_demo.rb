#!/usr/bin/env ruby
# frozen_string_literal: true

require 'valkey_glide'
require 'socket'

# Create UDS server instance
socket_path = '/tmp/valkey_glide.sock'
server = ValKeyGlide.new(socket_path)
server.start

# Create a client socket
client = UNIXSocket.new(socket_path)

# Send a message to the server
message = "Hello from Ruby!"
client.write(message)

# Read the response
response = client.read
puts "Server response: #{response}"

# Clean up
client.close
