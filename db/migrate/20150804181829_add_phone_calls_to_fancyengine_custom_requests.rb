class AddPhoneCallsToFancyengineCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :phone_calls, :text, default: "[]"
    reversible do |dir|
      dir.up do
        Fancyengine::CustomRequest.find_each do |custom_request|
          custom_request.save!
        end
      end
    end
  end
end
