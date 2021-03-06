require "fancyhands"

module TaskMaster
  class Client
    extend Forwardable
    def_delegators :@client, :request

    def initialize(key = TaskMaster.key, secret = TaskMaster.secret)
      unless key.present? && secret.present?
        raise ArgumentError, "Credentials are not configured. Set TaskMaster.key and TaskMaster.secret with your Fancy Hands credentials."
      end
      @client = FancyHands::V1::Client.new(key, secret)
    end

    def ping
      request.get("echo", {}) == {}
    end

    def create_custom_request(data)
      request.post("request/custom", data)
    end

    def cancel_custom_request(key)
      response = request.post("request/custom/cancel", { key: key })
      response["status"] == true
    end

    def trigger_callback(key)
      response = request.post("callback", { key: key })
      response["status"] == "ok"
    end

  end
end
