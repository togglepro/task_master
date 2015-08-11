class Manager < ActiveRecord::Base
  has_many :custom_requests, class_name: "TaskMaster::CustomRequest", as: :requestor
end
