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

**1. Install the gem.**
```ruby
# Gemfile
gem "fancyengine"
```

**2. Mount the engine.**
```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount Fancyengine::Engine => "/fancyengine"
end
```

**3. Run the engine's migrations.**
```bash
bundle exec rake fancyengine:install:migrations
bundle exec rake db:migrate
```

**4. Set your Fancy Hands application API key and secret.**

You'll need to create your application and get its secret and key at [http://www.fancyhands.com/developer](). The instructions below assume that you've saved them in environment variables.

```ruby
# config/intializers/fancyengine.rb
Fancyengine.key = ENV["FANCYHANDS_KEY"]
Fancyengine.secret = ENV["FANCYHANDS_SECRET"]
```

### Usage

Currently, the engine supports the following types of requests:

1. `CustomRequest`: A semi-structured task where you provide a description of the data that you'd like back and a price that you're willing to pay. The assistant will figure out how to best get the work done. You can create a relationship between a custom request and another model by setting the polymorphic `requestor` attribute on the custom request.

The engine provides an endpoint for Fancy Hands webhooks at `wherever-you-mount-the-engine/webhook`. You'll need to add the URL to your Fancy Hands application. When a request is received by the webhook controller it will find the matching request and add the response onto the array of responses for that instance.

### Credits

The library was originally written by [@barelyknown](http://twitter.com/barelyknown) using the API and Ruby client library from Fancy Hands.
