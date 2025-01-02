# frozen_string_literal: true

# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: response.proto

require "google/protobuf"

descriptor_data = "\n\x0eresponse.proto\x12\x08response\"I\n\x0cRequestError\x12(\n\x04type\x18\x01 \x01(\x0e\x32\x1a.response.RequestErrorType\x12\x0f\n\x07message\x18\x02 \x01(\t\"\xd5\x01\n\x08Response\x12\x14\n\x0c\x63\x61llback_idx\x18\x01 \x01(\r\x12\x16\n\x0cresp_pointer\x18\x02 \x01(\x04H\x00\x12\x37\n\x11\x63onstant_response\x18\x03 \x01(\x0e\x32\x1a.response.ConstantResponseH\x00\x12/\n\rrequest_error\x18\x04 \x01(\x0b\x32\x16.response.RequestErrorH\x00\x12\x17\n\rclosing_error\x18\x05 \x01(\tH\x00\x12\x0f\n\x07is_push\x18\x06 \x01(\x08\x42\x07\n\x05value*O\n\x10RequestErrorType\x12\x0f\n\x0bUnspecified\x10\x00\x12\r\n\tExecAbort\x10\x01\x12\x0b\n\x07Timeout\x10\x02\x12\x0e\n\nDisconnect\x10\x03*\x1a\n\x10\x43onstantResponse\x12\x06\n\x02OK\x10\x00\x62\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool

begin
  pool.add_serialized_file(descriptor_data)
rescue TypeError
  # Compatibility code: will be removed in the next major version.
  require "google/protobuf/descriptor_pb"
  parsed = Google::Protobuf::FileDescriptorProto.decode(descriptor_data)
  parsed.clear_dependency
  serialized = parsed.class.encode(parsed)
  file = pool.add_serialized_file(serialized)
  warn "Warning: Protobuf detected an import path issue while loading generated file #{__FILE__}"
  imports = []
  imports.each do |type_name, expected_filename|
    import_file = pool.lookup(type_name).file_descriptor
    if import_file.name != expected_filename
      warn "- #{file.name} imports #{expected_filename}, but that import was loaded as #{import_file.name}"
    end
  end
  warn "Each proto file must use a consistent fully-qualified name."
  warn "This will become an error in the next major version."
end

module Response
  RequestError = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("response.RequestError").msgclass
  Response = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("response.Response").msgclass
  RequestErrorType = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("response.RequestErrorType").enummodule
  ConstantResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("response.ConstantResponse").enummodule
end
