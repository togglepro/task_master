module Fancyengine
  class Client
    extend Forwardable
    def_delegators :@client, :request

    def initialize(key = Fancyengine.key, secret = Fancyengine.secret)
      unless key.present? && secret.present?
        raise ArgumentError, "Credentials are not configured. Set Fancyengine.key and Fancyengine.secret with your Fancy Hands credentials."
      end
      @client = FancyHands::V1::Client.new(key, secret)
    end

    def ping
      request.get("echo", {}) == {}
    end

  end
end
