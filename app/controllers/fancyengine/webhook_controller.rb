module Fancyengine
  class WebhookController < ApplicationController

    def create
      response = JSON.parse(request.body.read)

      request_instance = nil

      [CustomRequest].each do |request_class|
        break if request_instance = request_class.find_by(key: response["key"])
      end

      if request_instance
        request_instance.responses << response
        request_instance.save!
      end

      head :ok
    end

  end
end
