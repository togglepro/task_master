class AddMessagesToFancyengineCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :messages, :text, default: "[]"

    reversible do |dir|
      dir.up do
        Fancyengine::CustomRequest.find_each do |custom_request|
          custom_request.save!
        end
      end
    end
  end
end
