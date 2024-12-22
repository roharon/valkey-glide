# frozen_string_literal: true

require_relative "setup"

driver = ENV.fetch("DRIVER", "ruby").to_sym
# redis_client = RedisClient.new(host: "localhost", port: Servers::REDIS.real_port, driver: driver)
# redis = Redis.new(host: "localhost", port: Servers::REDIS.real_port, driver: driver)

redis_client = RedisClient.new
redis = Redis.new
valkey = Valkey.new


redis_client.call("SET", "key", "value")
redis_client.call("SET", "large", "value" * 10_000)
redis_client.call("LPUSH", "list", *5.times.to_a)
redis_client.call("LPUSH", "large-list", *1000.times.to_a)
redis_client.call("HMSET", "hash", *8.times.to_a)
redis_client.call("HMSET", "large-hash", *1000.times.to_a)

benchmark("small string") do |x|
  x.report("valkey") { valkey.get("key") }
  x.report("redis-rb") { redis.get("key") }
  x.report("redis-client") { redis_client.call("GET", "key") }
end
