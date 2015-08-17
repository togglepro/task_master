## TaskMaster

A Rails engine for outsourcing manual tasks (phone calls, research, and similar 'human' activities) using the Fancy Hands API.

### What is Fancy Hands?

Fancy Hands provides on-demand labor for remote tasks that can be done by someone in the US with relatively little context in a relatively short amount of time.

You can learn more about Fancy Hands at [http://www.fancyhands.com]() and about their API and developer program  at [http://www.fancyhands.com/developer]().

**If you use the referral code `TASKMASTER` at [https://www.fancyhands.com/developer/apps/new]() you'll get an EXTRA $20 of credits from Fancy Hands.**

### Why was TaskMaster created?

TaskMaster was created for three main reasons:
1. To provide an easy way to define and persist Fancy Hands requests.
2. To handle the outbound integration to create the requests using the Fancy Hands API.
3. To handle the inbound integration to update the requests using Fancy Hands webhooks.

### Installation

To install and use TaskMaster.

**1. Install the gem.**
```ruby
# Gemfile
gem "task_master"
```

**2. Mount the engine.**
```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount TaskMaster::Engine => "/task_master"
end
```

**3. Run the engine's migrations.**
```bash
bundle exec rake task_master:install:migrations
bundle exec rake db:migrate
```

**4. Set your Fancy Hands application API key and secret.**

You'll need to create your application and get its secret and key at [http://www.fancyhands.com/developer](). The instructions below assume that you've saved them in environment variables.

```ruby
# config/intializers/task_master.rb
TaskMaster.key = ENV["FANCYHANDS_KEY"]
TaskMaster.secret = ENV["FANCYHANDS_SECRET"]
```

### Usage

Currently, the engine supports the following types of requests:

1. `CustomRequest`

A semi-structured task where you provide a description of the data that you'd like back and a price that you're willing to pay. The assistant will figure out how to best get the work done. You can create a relationship between a custom request and another model by setting the polymorphic `requestor` attribute on the custom request.

Read the specs for more detail about all the features. The use of the `TaskMaster::CustomRequest` class will look something like this:

```ruby
# In this example, `ProfileUpdate` is a class in your app.
profile_update = ProfileUpdate.find(1)
custom_request = TaskMaster::CustomRequest.new(requestor: profile_update)
custom_request.title = "Call Supplier to Update Profile"
custom_request.description = <<-EOS
Please follow the following steps:
1. Find the supplier's contact info. The company's name is #{profile_update.company_name}.
2. Call them.
3. Collect the information in the form.
EOS
custom_request.custom_fields = [
  TaskMaster::CustomRequestField.new(
    type: "email",
    label: "Email",
    description: "The contact email of the supplier.",
    field_name: "email_address",
    required: false,
    order: 1
  ),
  TaskMaster::CustomRequestField.new(
    type: "tel",
    label: "Phone Number",
    description: "The contact phone number of the supplier.",
    field_name: "phone_number",
    required: false,
    order: 2
  )
]
custom_request.bid = "3.0"
custom_request.expiration_date = Time.now + 3.days
custom_request.save!
```

The custom request will post the request to Fancy Hands after commit (which can be async'd easily if you just override `post_to_fancyhands` in `TaskMaster::CustomRequest`).

The engine provides an endpoint for Fancy Hands webhooks at `wherever-you-mount-the-engine/webhook`. You'll need to add the URL to your Fancy Hands application. When a request is received by the webhook controller it will find the matching request and add the response onto the array of responses for that instance (and parse those responses into other attributes).

The code should be easy to read - take a look at the `TaskMaster::CustomRequest` and `TaskMaster::CustomRequestField` classes and their specs for more details.

### Feedback

I'll add the other types of requests as I need them OR when the community needs it. Create an issue to chat about this more.

### Credits

The library was originally written by [@barelyknown](http://twitter.com/barelyknown) using the API and Ruby client library from Fancy Hands. If you need help designing or building your Fancy Hands integration, let me know.
