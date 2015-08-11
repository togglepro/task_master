FactoryGirl.define do
  factory :task_master_custom_request_field, :class => "TaskMaster::CustomRequestField" do
    type "text"
    label "Sounds like?"
    description ("-" * 300)
    field_name "person_sounds_like"
    required false
    order 1
  end
  factory :task_master_custom_request_field_invalid, :class => "TaskMaster::CustomRequestField" do
    type "bologna"
    label nil
    description nil
    field_name nil
    required false
    order -1
  end
end
