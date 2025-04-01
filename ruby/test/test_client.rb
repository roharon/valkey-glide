# frozen_string_literal: true

require_relative 'test_helper'

class ClientTest < Minitest::Test
  def setup
    @client = ValkeyGlide.client(
      host: 'localhost',
      port: 6379
    )
  end

  def teardown
    @client.close if @client
  end

  def test_client_initialization
    assert @client, "Client should be initialized"
    assert_instance_of ValkeyGlide::Client, @client, "Client should be an instance of ValkeyGlide::Client"
  end

  def test_ping
    response = @client.ping
    assert_equal "PONG", response, "Ping should return PONG"
  end

  def test_set_and_get
    @client.set("test_key", "test_value")
    value = @client.get("test_key")
    assert_equal "test_value", value, "Get should return the value set by set"
  end

  def test_del
    @client.set("test_del_key", "test_value")
    count = @client.del("test_del_key")
    assert_equal 1, count, "Del should return the number of keys deleted"
    value = @client.get("test_del_key")
    assert_nil value, "After deletion, get should return nil"
  end

  def test_exists
    @client.set("test_exists_key", "test_value")
    count = @client.exists("test_exists_key")
    assert_equal 1, count, "Exists should return the number of keys that exist"
    count = @client.exists("test_exists_key", "nonexistent_key")
    assert_equal 1, count, "Exists should return the number of keys that exist"
  end

  def test_expire_and_ttl
    @client.set("test_expire_key", "test_value")
    @client.expire("test_expire_key", 100)
    ttl = @client.ttl("test_expire_key")
    assert ttl > 0 && ttl <= 100, "TTL should be between 0 and 100"
  end

  def test_flushdb
    @client.set("test_flush_key", "test_value")
    response = @client.flushdb
    assert_equal "OK", response, "Flushdb should return OK"
    value = @client.get("test_flush_key")
    assert_nil value, "After flushdb, get should return nil"
  end
end
