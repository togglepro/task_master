RSpec.describe Manager do
  it "has many custom requests" do
    manager = Manager.create
    custom_request = FactoryGirl.build(:fancyengine_custom_request, requestor: manager)
    expect(custom_request).to receive(:post_to_fancyhands)
    custom_request.save!
    manager.reload
    expect(manager.custom_requests).to eq [custom_request]
  end
end
