class AddNumericStatusToTaskMasterCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :numeric_status, :integer
  end
end
