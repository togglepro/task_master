class RenameFancyengineCustomRequestsToTaskMasterCustomRequests < ActiveRecord::Migration
  def change
    if table_exists?(:fancyengine_custom_requests)
      rename_table :fancyengine_custom_requests, :task_master_custom_requests
    end
  end
end
