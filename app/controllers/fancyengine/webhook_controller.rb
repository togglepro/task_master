module Fancyengine
  class WebhookController < ApplicationController

    def create
      response = JSON.parse(request.body.read)

      request_instance = nil

      if response["key"].nil?
        head :bad_request and return
      end

      [CustomRequest].each do |request_class|
        break if request_instance = request_class.find_by(key: response["key"])
      end

      if request_instance
        request_instance.responses << response
        request_instance.save!
      end

      head :ok

    rescue JSON::ParserError
      head :bad_request
    end

  end
end
