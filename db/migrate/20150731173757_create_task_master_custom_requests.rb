class CreateTaskMasterCustomRequests < ActiveRecord::Migration
  def change
    create_table :task_master_custom_requests do |t|
      t.string :title
      t.text :description, null: false
      t.text :custom_fields, null: false
      t.decimal :bid, null: false
      t.datetime :expiration_date, null: false
      t.string :key
      t.text :responses, default: "[]"
      t.integer :numeric_status
      t.datetime :fancyhands_created_at
      t.datetime :fancyhands_updated_at
      t.datetime :fancyhands_closed_at
      t.text :answers, default: "{}"
      t.reference :requestor, polymorphic: true
      t.text :messages, :text, default: "[]"
      t.text :phone_calls, :text, default: "[]"
      t.boolean :closed_without_answers, default: false
      t.integer :phone_call_seconds, :integer, default: 0

      t.timestamps null: false
    end
    add_index :task_master_custom_requests, [:requestor_id, :requestor_type], name: "idx_fcr_ri_rt"
  end
end
