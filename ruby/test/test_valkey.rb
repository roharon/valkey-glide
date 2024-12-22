# frozen_string_literal: true

require "test_helper"

class TestValkey < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Valkey::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_felan
      client = Valkey.new

      pp client.set("foo", "bar")

      assert_equal client.get("foo"), "bar"
  end
end
