# frozen_string_literal: true

require_relative 'test_helper'

class StringOptionsTest < Minitest::Test
  def setup
    @client = ValkeyGlide.client(
      host: 'localhost',
      port: 6379
    )
    @client.flushdb # Clear the database before each test
  end

  def teardown
    @client.close if @client
  end

  def test_get_with_getex_options
    @client.set("test_key", "test_value")

    # Test GetEx options builder
    options = ValkeyGlide::Options.getex do |opt|
      opt.ex(10)
    end

    assert_equal "test_value", @client.getex("test_key", options)
    assert_operator @client.ttl("test_key"), :<=, 10
    assert_operator @client.ttl("test_key"), :>=, 0
  end

  def test_get_with_persist_option
    @client.set("test_key", "test_value", ex: 30)
    assert_operator @client.ttl("test_key"), :>, 0

    options = ValkeyGlide::Options.getex do |opt|
      opt.persist
    end

    assert_equal "test_value", @client.getex("test_key", options)
    assert_equal -1, @client.ttl("test_key")
  end

  def test_set_with_nx_option
    # Set a key with NX option
    set_options = ValkeyGlide::Options.set do |opt|
      opt.nx
    end

    assert_equal "OK", @client.set("test_nx", "value1", set_options)

    # Try to set again with NX - should return nil
    assert_nil @client.set("test_nx", "value2", set_options)

    # Verify value wasn't changed
    assert_equal "value1", @client.get("test_nx")
  end

  def test_set_with_xx_option
    # Set a key with XX option (should fail if key doesn't exist)
    set_options = ValkeyGlide::Options.set do |opt|
      opt.xx
    end

    assert_nil @client.set("test_xx", "value1", set_options)

    # Create the key first
    @client.set("test_xx", "original")

    # Now XX should work
    assert_equal "OK", @client.set("test_xx", "updated", set_options)

    # Verify value was changed
    assert_equal "updated", @client.get("test_xx")
  end

  def test_set_with_expiry_options
    # Test different expiry options
    ex_options = ValkeyGlide::Options.set do |opt|
      opt.ex(10)
    end

    px_options = ValkeyGlide::Options.set do |opt|
      opt.px(5000)
    end

    @client.set("test_ex", "ex_value", ex_options)
    @client.set("test_px", "px_value", px_options)

    assert_operator @client.ttl("test_ex"), :<=, 10
    assert_operator @client.ttl("test_ex"), :>, 0

    assert_operator @client.ttl("test_px"), :<=, 5
    assert_operator @client.ttl("test_px"), :>, 0
  end

  def test_set_with_get_option
    # Set with GET option to get old value
    @client.set("test_get", "old_value")

    get_options = ValkeyGlide::Options.set do |opt|
      opt.get
    end

    assert_equal "old_value", @client.set("test_get", "new_value", get_options)
    assert_equal "new_value", @client.get("test_get")

    # When key doesn't exist, should return nil
    assert_nil @client.set("nonexistent", "value", get_options)
  end

  def test_chained_options
    # Test chained option methods
    options = ValkeyGlide::Options.set do |opt|
      opt.ex(10).nx.get
    end

    # This should set the key with expiry
    assert_nil @client.set("test_chain", "value1", options)
    assert_operator @client.ttl("test_chain"), :<=, 10
    assert_operator @client.ttl("test_chain"), :>, 0

    # This should not set the key but return the old value
    assert_equal "value1", @client.set("test_chain", "value2", options)

    # Value should not change
    assert_equal "value1", @client.get("test_chain")
  end
end
