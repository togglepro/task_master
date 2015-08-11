class Manager < ActiveRecord::Base
  has_many :custom_requests, class_name: "TaskEngine::CustomRequest", as: :requestor
end
