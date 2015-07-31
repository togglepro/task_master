module Fancyengine
  RSpec.describe CustomRequest do

    before do
      # using a request instance variable so that we can immediately cancel
      # requests that are created in fancy hands
      @request = described_class.new
    end

    it "has a title attribute" do
      title = "Custom Request"
      @request.title = title
      expect(@request.title).to eq title
    end

    it "has a description attribute" do
      description = "Make the following three phone calls and send me the duration."
      @request.description = description
      expect(@request.description).to eq description
    end

    it "validates the presence of the description attribute" do
      @request.description = nil
      @request.valid?
      expect(@request.errors[:description]).to include "can't be blank"
    end

    it "has a custom_fields attribute that is initialized as an empty array" do
      expect(@request.custom_fields).to eq []
    end

    it "validates that the custom_fields is not empty" do
      @request.custom_fields = []
      @request.valid?
      expect(@request.errors[:custom_fields]).to include "can't be empty"
    end

    it "validates that each custom_field is valid" do
      @request.custom_fields = [FactoryGirl.build(:fancyengine_custom_request_field)]
      @request.valid?
      expect(@request.errors[:custom_fields]).to be_empty
      @request.custom_fields = [FactoryGirl.build(:fancyengine_custom_request_field_invalid)]
      @request.valid?
      expect(@request.errors[:custom_fields]).not_to be_empty
    end

    it "has a bid attribute that is a decimal" do
      bid = "2.50"
      @request.bid = bid
      expect(@request.bid).to eq BigDecimal(bid)
    end

    it "has an expiration_date attribute" do
      expiration_date = Time.now
      @request.expiration_date = expiration_date
      expect(@request.expiration_date).to eq expiration_date
    end

    it "has a key attribute" do
      key = SecureRandom.hex
      @request.key = key
      expect(@request.key).to eq key
    end

    it "has a factory that can build a valid instance" do
      @request = FactoryGirl.build(:fancyengine_custom_request)
      expect(@request).to be_valid
    end

    it "creates the request in fancy hands after commit and sets the key" do
      @request = FactoryGirl.create(:fancyengine_custom_request)
      @request.reload
      expect(@request).to be_persisted
      expect(@request.key).not_to be_blank
    end

    # cancel the requests if they're created since they don't have a test system
    after do
      if @request.persisted? && @request.key.present?
        @request.cancel
      end
    end

  end
end
