class AddRequestorToCustomRequests < ActiveRecord::Migration
  def change
    add_reference :fancyengine_custom_requests, :requestor, polymorphic: true
    add_index :fancyengine_custom_requests, [:requestor_id, :requestor_type], name: "idx_fcr_ri_rt"
  end
end
