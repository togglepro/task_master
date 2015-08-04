class AddClosedWithoutAnswersToFancyengineCustomRequests < ActiveRecord::Migration
  def change
    add_column :fancyengine_custom_requests, :closed_without_answers, :boolean, default: false

    reversible do |dir|
      dir.up do
        Fancyengine::CustomRequest.reset_column_information
        Fancyengine::CustomRequest.find_each do |custom_request|
          custom_request.save!
        end
      end
    end
  end
end
