# frozen_string_literal: true

require "test_helper"

class StringCommandsTest < Minitest::Test
  def setup
    @client = ValkeyGlide::Client.new
    @client.flushdb # Clean database before each test
  end

  def teardown
    @client.close
  end

  # GET command tests
  def test_get_returns_string_value
    @client.set("test_key", "test_value")
    assert_equal "test_value", @client.get("test_key")
  end

  def test_get_returns_nil_for_nonexistent_key
    assert_nil @client.get("nonexistent_key")
  end

  def test_get_after_expiration
    @client.set("expiring_key", "will_expire", ex: 1)
    assert_equal "will_expire", @client.get("expiring_key")
    sleep 1.1 # Sleep a bit more than the expiry time
    assert_nil @client.get("expiring_key")
  end

  def test_get_wrong_type_raises_error
    @client.execute_command("HSET", "hash_key", "field", "value")
    assert_raises(ValkeyGlide::TypeError) do
      @client.get("hash_key")
    end
  end

  # GETEX command tests
  def test_getex_returns_value_and_sets_expiry
    @client.set("test_key", "test_value")
    assert_equal "test_value", @client.getex("test_key", ex: 10)
    assert_operator @client.ttl("test_key"), :>, 0
    assert_operator @client.ttl("test_key"), :<=, 10
  end
  
  def test_getex_with_persist_removes_expiry
    @client.set("test_key", "test_value", ex: 30)
    assert_operator @client.ttl("test_key"), :>, 0
    assert_equal "test_value", @client.getex("test_key", persist: true)
    assert_equal -1, @client.ttl("test_key") # -1 means no expiry
  end
  
  # GETDEL command tests
  def test_getdel_returns_value_and_deletes_key
    @client.set("test_key", "test_value")
    assert_equal "test_value", @client.getdel("test_key")
    assert_nil @client.get("test_key")
  end
  
  def test_getdel_returns_nil_for_nonexistent_key
    assert_nil @client.getdel("nonexistent_key")
  end
  
  # GETRANGE command tests
  def test_getrange_returns_substring
    @client.set("test_key", "Hello Valkey")
    assert_equal "Hello", @client.getrange("test_key", 0, 4)
    assert_equal "Valkey", @client.getrange("test_key", 6, 11)
    assert_equal "Hello Valkey", @client.getrange("test_key", 0, -1)
    assert_equal "Valkey", @client.getrange("test_key", -6, -1)
  end
  
  def test_getrange_returns_empty_string_for_nonexistent_key
    assert_equal "", @client.getrange("nonexistent_key", 0, 10)
  end
  
  # STRLEN command tests
  def test_strlen_returns_string_length
    @client.set("test_key", "Hello Valkey")
    assert_equal 12, @client.strlen("test_key")
  end
  
  def test_strlen_returns_zero_for_nonexistent_key
    assert_equal 0, @client.strlen("nonexistent_key")
  end
  
  # SET command tests
  def test_set_basic
    assert_equal "OK", @client.set("test_key", "test_value")
    assert_equal "test_value", @client.get("test_key")
  end
  
  def test_set_with_expiry
    @client.set("test_key", "test_value", ex: 1)
    assert_operator @client.ttl("test_key"), :<=, 1
    sleep 1.1
    assert_nil @client.get("test_key")
  end
  
  def test_set_nx_option
    assert_equal "OK", @client.set("test_key", "original", nx: true)
    assert_nil @client.set("test_key", "updated", nx: true)
    assert_equal "original", @client.get("test_key")
  end
  
  def test_set_xx_option
    assert_nil @client.set("test_key", "won't set", xx: true)
    @client.set("test_key", "original")
    assert_equal "OK", @client.set("test_key", "updated", xx: true)
    assert_equal "updated", @client.get("test_key")
  end
  
  def test_set_get_option
    @client.set("test_key", "original")
    assert_equal "original", @client.set("test_key", "updated", get: true)
    assert_equal "updated", @client.get("test_key")
  end
  
  def test_set_keepttl_option
    @client.set("test_key", "original", ex: 10)
    ttl_before = @client.ttl("test_key")
    @client.set("test_key", "updated", keepttl: true)
    ttl_after = @client.ttl("test_key")
    assert_operator ttl_before, :>=, ttl_after
    assert_operator ttl_after, :>, 0
  end
  
  # Multiple key command tests
  def test_mset_and_mget
    @client.mset(key1: "value1", key2: "value2", key3: "value3")
    values = @client.mget("key1", "key2", "key3", "nonexistent")
    assert_equal ["value1", "value2", "value3", nil], values
  end
  
  def test_msetnx
    assert_equal true, @client.msetnx(key1: "value1", key2: "value2")
    assert_equal false, @client.msetnx(key3: "value3", key1: "new_value1")
    assert_equal "value1", @client.get("key1")
    assert_nil @client.get("key3")
  end
  
  # Increment/decrement tests
  def test_incr
    @client.set("counter", "10")
    assert_equal 11, @client.incr("counter")
    assert_equal 12, @client.incr("counter")
  end
  
  def test_incrby
    @client.set("counter", "10")
    assert_equal 15, @client.incrby("counter", 5)
    assert_equal 5, @client.incrby("counter", -10)
  end
  
  def test_decr
    @client.set("counter", "10")
    assert_equal 9, @client.decr("counter")
    assert_equal 8, @client.decr("counter")
  end
  
  def test_decrby
    @client.set("counter", "10")
    assert_equal 5, @client.decrby("counter", 5)
    assert_equal 15, @client.decrby("counter", -10)
  end
  
  def test_incrbyfloat
    @client.set("pi", "3.0")
    assert_in_delta 3.14159, @client.incrbyfloat("pi", 0.14159), 0.00001
  end
end
