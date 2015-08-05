class AddClosedWithoutAnswersToFancyengineCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :closed_without_answers, :boolean, default: false

  end
end
