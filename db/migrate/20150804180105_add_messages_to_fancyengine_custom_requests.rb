class AddMessagesToTaskEngineCustomRequests < ActiveRecord::Migration
  def change
    unless column_exists?(:fancyengine_custom_requests, :messages)
      add_column :fancyengine_custom_requests, :messages, :text, default: "[]"
    end

    unless column_exists?(:fancyengine_custom_requests, :phone_calls)
      add_column :fancyengine_custom_requests, :phone_calls, :text, default: "[]"
    end

  end
end
