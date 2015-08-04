FactoryGirl.define do
  factory :fancyengine_custom_request, :class => 'Fancyengine::CustomRequest' do
    title "TESTING: This is not a real request."
    description "This request will be cancelled shortly. Please do not work on it."
    custom_fields [FactoryGirl.build(:fancyengine_custom_request_field)]
    bid "0.01"
    expiration_date Time.now + 1.minute
    key nil
  end
end
