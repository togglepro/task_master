class AddFancyhandsClosedAtToTaskEngineCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :fancyhands_closed_at, :datetime

    reversible do |dir|
      dir.up do
        TaskEngine::CustomRequest.reset_column_information
        TaskEngine::CustomRequest.find_each do |custom_request|
          custom_request.save!
        end
      end
    end

  end
end
