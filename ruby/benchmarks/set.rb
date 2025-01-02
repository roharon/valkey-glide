require_relative '../lib/valkey.rb'
require 'benchmark/ips'
require 'redis'
require 'redis-client'

client = ::Valkey.new
redis = Redis.new
redis_client = RedisClient.new

Benchmark.ips do |x|
  x.warmup = 1
  x.time = 5

  x.report('set_v1') do
    client.set_v1('foo', 'bar')
  end

  x.report('set_v2') do
    client.set_v2('foo', 'bar')
  end

  x.report('redis') do
    redis.set('foo', 'bar')
  end

  x.report('redis-client') do
    redis_client.call('SET', 'foo', 'bar')
  end

  x.compare!
end


long_string = 'a' * 1000

Benchmark.ips do |x|
  x.warmup = 1
  x.time = 5

  x.report('set_v1') do
    client.set_v1('foo', long_string)
  end

  x.report('set_v2') do
    client.set_v2('foo', long_string)
  end

  x.report('redis') do
    redis.set('foo', long_string)
  end

  x.report('redis-client') do
    redis_client.call('SET', 'foo', long_string)
  end

  x.compare!
end
