use magnus::{function, method, prelude::*, Error, Module, Object, RArray, RHash, RString, Ruby, value::Value, value::qnil, value, IntoValue};

use glide_ffi::{
    RequestType, close_client, command, create_client, free_command_result,
    free_connection_response, ClientType, CommandResponse, ConnectionResponse, ResponseType
};
use std::ffi::CStr;
use std::os::raw::{c_ulong, c_void};
use std::ptr;

// Constants for request types based on glide-core RequestType enum
const REQUEST_TYPE_NORMAL: i32 = 1;

// Client wrapper for Valkey GLIDE
struct ValkeyGlideClient {
    client_ptr: *const c_void,
}

impl ValkeyGlideClient {
    unsafe fn new(connection_request: RHash, client_type_str: String) -> Result<Self, Error> {
        // Serialize connection_request to bytes
        // let ruby = unsafe { Ruby::get() };
        let connection_request_bytes = match connection_request.to_s() {
            Ok(s) => s.as_bytes().to_vec(),
            Err(e) => return Err(Error::new(
                magnus::exception::arg_error(),
                format!("Failed to convert connection request to string: {}", e),
            )),
        };

        // Create appropriate client type
        let client_type = if client_type_str == "sync" {
            ClientType::SyncClient
        } else {
            return Err(Error::new(
                magnus::exception::arg_error(),
                format!("Invalid client type: {}. Only 'sync' is supported.", client_type_str),
            ));
        };

        // Create client type pointer
        let client_type_box = Box::new(client_type);
        let client_type_ptr = Box::into_raw(client_type_box);

        // Create client
        let connection_response = unsafe {
            create_client(
                connection_request_bytes.as_ptr(),
                connection_request_bytes.len(),
                client_type_ptr as *const ClientType,
            )
        };

        // Free client_type_box memory
        unsafe { drop(Box::from_raw(client_type_ptr)) };

        // Check for null response
        if connection_response.is_null() {
            return Err(Error::new(
                magnus::exception::runtime_error(),
                "Failed to create client: null response",
            ));
        }

        // Check for error in response
        let response = unsafe { &*connection_response };
        if !response.connection_error_message.is_null() {
            let error_message = unsafe {
                CStr::from_ptr(response.connection_error_message)
                    .to_string_lossy()
                    .into_owned()
            };
            unsafe { free_connection_response(connection_response as *mut ConnectionResponse) };
            return Err(Error::new(
                magnus::exception::runtime_error(),
                format!("Failed to create client: {}", error_message),
            ));
        }

        // Success
        Ok(ValkeyGlideClient {
            client_ptr: response.conn_ptr,
        })
    }

    fn command(&self, requestType: RequestType, command_args: RArray) -> Result<Value, Error> {
        let ruby = unsafe { Ruby::get() };

        // Convert Ruby array to Vec<String>
        let mut args: Vec<String> = Vec::with_capacity(command_args.len());
        for i in 0..command_args.len() as isize {
            let arg = command_args.entry(i)?;
            args.push(arg.to_s()?.to_string());
        }

        // Convert strings to bytes
        let mut arg_bytes: Vec<Vec<u8>> = Vec::with_capacity(args.len());
        for arg in &args {
            arg_bytes.push(arg.as_bytes().to_vec());
        }

        // Create pointers and lengths arrays
        let mut arg_ptrs: Vec<usize> = Vec::with_capacity(args.len());
        let mut arg_lens: Vec<c_ulong> = Vec::with_capacity(args.len());

        for arg in &arg_bytes {
            arg_ptrs.push(arg.as_ptr() as usize);
            arg_lens.push(arg.len() as c_ulong);
        }

        // Execute the command
        let command_result = unsafe {
            command(
                self.client_ptr,
                0,  // channel (not used for sync)
                requestType,
                args.len() as c_ulong,
                arg_ptrs.as_ptr(),
                arg_lens.as_ptr(),
                ptr::null(),  // route_bytes
                0,            // route_bytes_len
            )
        };

        // Check for null result
        if command_result.is_null() {
            return Err(Error::new(
                magnus::exception::runtime_error(),
                "Command execution failed: null result",
            ));
        }

        // Handle result
        let result = unsafe { &*command_result };

        // Check for error
        if !result.command_error.is_null() {
            let error = unsafe { &*result.command_error };
            let error_message = unsafe {
                CStr::from_ptr(error.command_error_message)
                    .to_string_lossy()
                    .into_owned()
            };
            let error_type = error.command_error_type;

            unsafe { free_command_result(command_result) };

            return Err(Error::new(
                magnus::exception::runtime_error(),
                format!("Command error (type: {:?}): {}", error_type, error_message),
            ));
        }

        // Handle null response
        if result.response.is_null() {
            unsafe { free_command_result(command_result) };
            return Ok(qnil().into_value());
        }

        // Convert response to Ruby object
        let response = unsafe { &*result.response };
        let ruby_response = self.command_response_to_ruby(response)?;

        // Free result
        unsafe { free_command_result(command_result) };

        Ok(ruby_response)
    }

    fn command_response_to_ruby(&self, response: &CommandResponse) -> Result<Value, Error> {
        match response.response_type {
            ResponseType::Null => Ok(qnil().into_value()),

            ResponseType::Int => Ok(response.int_value.into_value()),

            ResponseType::Float => Ok(response.float_value.into_value()),

            ResponseType::Bool => Ok(response.bool_value.into_value()),

            ResponseType::String => {
                if response.string_value.is_null() {
                    return Ok(value::qnil().into_value());
                }

                let string_data = unsafe {
                    std::slice::from_raw_parts(
                        response.string_value as *const u8,
                        response.string_value_len as usize,
                    )
                };

                Ok(RString::from_slice(string_data).as_value())
            },

            ResponseType::Array => {
                if response.array_value.is_null() {
                    return Ok(qnil().into_value());
                }

                let array_values = unsafe {
                    std::slice::from_raw_parts(
                        response.array_value,
                        response.array_value_len as usize,
                    )
                };

                let ruby_array = RArray::with_capacity(array_values.len());

                for (idx, value) in array_values.iter().enumerate() {
                    let ruby_value = self.command_response_to_ruby(value)?;
                    ruby_array.store(idx as isize, ruby_value)?;
                }

                Ok(ruby_array.as_value())
            },

            ResponseType::Map => {
                if response.array_value.is_null() {
                    return Ok(qnil().into_value());
                }

                let map_entries = unsafe {
                    std::slice::from_raw_parts(
                        response.array_value,
                        response.array_value_len as usize,
                    )
                };

                let ruby_hash = RHash::new();

                for entry in map_entries {
                    if entry.map_key.is_null() || entry.map_value.is_null() {
                        continue;
                    }

                    let key = unsafe { &*entry.map_key };
                    let value = unsafe { &*entry.map_value };

                    let ruby_key = self.command_response_to_ruby(key)?;
                    let ruby_value = self.command_response_to_ruby(value)?;

                    ruby_hash.aset(ruby_key, ruby_value)?;
                }

                Ok(ruby_hash.as_value())
            },

            ResponseType::Sets => {
                if response.sets_value.is_null() {
                    return Ok(qnil().into_value());
                }

                let set_values = unsafe {
                    std::slice::from_raw_parts(
                        response.sets_value,
                        response.sets_value_len as usize,
                    )
                };

                let ruby_array = RArray::with_capacity(set_values.len());

                for (idx, value) in set_values.iter().enumerate() {
                    let ruby_value = self.command_response_to_ruby(value)?;
                    ruby_array.store(idx as isize, ruby_value)?;
                }

                Ok(ruby_array.as_value())
            },
        }
    }
}

impl Drop for ValkeyGlideClient {
    fn drop(&mut self) {
        if !self.client_ptr.is_null() {
            unsafe {
                close_client(self.client_ptr);
            }
            self.client_ptr = ptr::null();
        }
    }
}

// Register the ValkeyGlide module and Client class
#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    // Define ValkeyGlide module
    let module = ruby.define_module("ValkeyGlide")?;

    // Define Client class
    let client_class = module.define_class("Client", ruby.class_object())?;

    // Define methods
    client_class.define_singleton_method("new", function!(ValkeyGlideClient::new, 2))?;
    client_class.define_method("command", function!(ValkeyGlideClient::command, 2))?;

    Ok(())
}
