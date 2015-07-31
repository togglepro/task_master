module Fancyengine
  class Client

    def initialize(key = Fancyengine.key, secret = Fancyengine.secret)
      unless key.present? && secret.present?
        raise ArgumentError, "credentials are not configured. Set Fancyengine.key and Fancyengine.secret with your Fancy Hands credentials."
      end
      @client = FancyHands::V1::Client.new(key, secret)
    end

    def ping
      @client.Echo.get({}) == {}
    end

  end
end
