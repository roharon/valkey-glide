# frozen_string_literal: true

require_relative "valkey/version"
require_relative "valkey/valkey"
# require_relative "valkey/client"
require_relative "valkey/protobuf/command_request_pb"
require_relative "valkey/protobuf/connection_request_pb"
require_relative "valkey/protobuf/response_pb"

#
# Valkey Client
#
class Valkey
  def initialize
    request = ConnectionRequest::ConnectionRequest.new(
      addresses: [ConnectionRequest::NodeAddress.new(host: "127.0.0.1", port: 6379)]
    )
    # request.request_timeout = 1000

    @client = Client.new(ConnectionRequest::ConnectionRequest.encode(request))
  end

  def set(key, value)
    request = CommandRequest::Command.new(
      request_type: CommandRequest::RequestType::Set,
      args_array: CommandRequest::Command::ArgsArray.new(args: [key, value])
    )

    @client.send_command(CommandRequest::Command.encode(request))
  end

  def get_v1(key)
    request = CommandRequest::Command.new(
      request_type: CommandRequest::RequestType::Get,
      args_array: CommandRequest::Command::ArgsArray.new(args: [key.b])
    )

    @client.send_command(CommandRequest::Command.encode(request))
  end

  def get_v2(key)
    @client.get_v2(key)
  end
end
