# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "valkey_glide"

require "minitest/autorun"

class Minitest::Test
  def run_with_rescue
    begin
      run_without_rescue
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace.join("\n")
      raise e
    end
  end
  
  alias run_without_rescue run
  alias run run_with_rescue
end
