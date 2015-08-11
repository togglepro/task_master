class AddPhoneCallSecondsToTaskEngineCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :phone_call_seconds, :integer, default: 0

  end
end
