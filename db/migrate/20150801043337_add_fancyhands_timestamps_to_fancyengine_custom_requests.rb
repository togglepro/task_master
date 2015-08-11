class AddFancyhandsTimestampsToTaskEngineCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :fancyhands_created_at, :datetime
    add_column :fancyengine_custom_requests, :fancyhands_updated_at, :datetime
  end
end
