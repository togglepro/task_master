## Fancyengine

A Rails engine for the Fancy Hands API.

### What is Fancy Hands?

Fancy Hands provides on-demand labor for remote tasks that can be done by someone in the US with relatively little context (no more than you give them) in a relatively short amount of time.

You can learn more about Fancy Hands at [http://www.fancyhands.com]() and about their API and developer program  at [http://www.fancyhands.com/developer]().

### Why was Fancyengine created?

Fancyengine was created for three main reasons:
1. To provide an easy way to define and persist Fancy Hands requests.
2. To handle the outbound integration to create the requests using the Fancy Hands API.
3. To handle the inbound integration to update the requests using Fancy Hands webhooks.

### Installation

To install and use Fancyengine.

**1. Install the gem**
```ruby
# Gemfile
gem "fancyengine"
```

**2. Mount the engine**
```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount Fancyengine::Engine => "/fancyengine"
end
```

**3. Run the engine's migrations**
```bash
bundle exec rake fancyengine:install:migrations
```

### Credits

The library was originally written by [@barelyknown](http://twitter.com/barelyknown) using the API and Ruby client library from Fancy Hands.
