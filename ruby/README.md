# Valkey

## Installation

```
$ gem install redis
```

## Usage

```ruby
require "valkey"

client = Valkey.new

client.set("mykey", "hello world")
# => "OK"


# using protobuf messaging method
client.get_v1("mykey")
# => "hello world"

# using direct extension method call
client.get_v2("mykey")
# => "hello world"
```

## Development

compile

```
$ bundle exec rake compile
```

run tests

```
$ bundle exec rake test
```
## Contributing
