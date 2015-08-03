class Manager < ActiveRecord::Base
  has_many :custom_requests, class_name: "Fancyengine::CustomRequest", as: :requestor
end
