class CreateTaskEngineCustomRequests < ActiveRecord::Migration
  def change
    create_table :fancyengine_custom_requests do |t|
      t.string :title
      t.text :description, null: false
      t.text :custom_fields, null: false
      t.decimal :bid, null: false
      t.datetime :expiration_date, null: false
      t.string :key

      t.timestamps null: false
    end
  end
end
