class RenameTaskEngineToTaskMaster < ActiveRecord::Migration
  def change
    if table_exists?(:task_engine_custom_requests)
      rename_table :task_engine_custom_requests, :task_master_custom_requests
    end
  end
end
