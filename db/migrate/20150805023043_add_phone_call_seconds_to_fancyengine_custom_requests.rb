class AddPhoneCallSecondsToFancyengineCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :phone_call_seconds, :integer, default: 0

    reversible do |dir|
      dir.up do
        Fancyengine::CustomRequest.reset_column_information
        Fancyengine::CustomRequest.find_each do |custom_request|
          custom_request.save!
        end
      end
    end

  end
end
