RSpec.describe Fancyengine::Client do

  context "when the key and secret are not configured" do
    it "raises a credentials not available error" do
      expect{described_class.new(nil, nil)}.to raise_error(ArgumentError)
    end
  end

  context "when the key and secret are configured" do
    it "initializes without error" do
      expect{subject}.not_to raise_error
    end

    it "can ping the server" do
      expect(subject.ping).to eq true
    end
  end
end
