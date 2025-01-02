require_relative '../lib/valkey.rb'
require 'benchmark/ips'
require 'redis'
require 'redis-client'

client = ::Valkey.new
redis = Redis.new
redis_client = RedisClient.new

client.set_v1('foo', 'bar')

Benchmark.ips do |x|
  x.warmup = 1
  x.time = 5

  x.report('get_v1') do
    client.get_v1('foo')
  end

  x.report('get_v2') do
    client.get_v2('foo')
  end

  x.report('redis') do
    redis.get('foo')
  end

  x.report('redis-client') do
    redis_client.call('GET', 'foo')
  end

  x.compare!
end
