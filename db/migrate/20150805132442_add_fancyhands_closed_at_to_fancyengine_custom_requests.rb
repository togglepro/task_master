class AddFancyhandsClosedAtToTaskMasterCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :fancyhands_closed_at, :datetime

    reversible do |dir|
      dir.up do
        TaskMaster::CustomRequest.reset_column_information
        TaskMaster::CustomRequest.find_each do |custom_request|
          custom_request.save!
        end
      end
    end

  end
end
