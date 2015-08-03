class AddAnswersToCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :answers, :text, default: "{}"
  end
end
