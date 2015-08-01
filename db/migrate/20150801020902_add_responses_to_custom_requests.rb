class AddResponsesToCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :responses, :text, default: "[]"
  end
end
