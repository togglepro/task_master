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

    it "has a responses attribute that is initialized as an empty array" do
      expect(@request.responses).to eq []
    end

    it "has a numeric_status attribute" do
      numeric_status = 1
      subject.numeric_status = numeric_status
      expect(subject.numeric_status).to eq numeric_status
    end

    it "validates that the numeric_status is a valid status" do
      subject.numeric_status = 100
      subject.valid?
      expect(subject.errors[:numeric_status]).to include "is not included in the list"
    end

    it "has a factory that can build a valid instance" do
      @request = FactoryGirl.build(:fancyengine_custom_request)
      expect(@request).to be_valid
    end

    it "creates the request in fancy hands after commit and sets the key and other attributes" do
      @request = FactoryGirl.build(:fancyengine_custom_request)

      response = JSON.parse(File.read(File.expand_path("../../../fixtures/custom_requests/response.json", __FILE__)))

      client = Client.new
      expect(Client).to receive(:new).twice.and_return(client)
      expect(client)
        .to(receive(:create_custom_request))
        .with(@request._to_fancy_hands_data)
        .and_return(response)
      expect(client)
        .to(receive(:cancel_custom_request))
        .with(response["key"])
        .and_return(true)

      @request.save!
      @request.reload
      expect(@request).to be_persisted
      expect(@request.key).to eq "ahBzfmZhbmN5aGFuZHMtaHJkcikLEgZGSFVzZXIYgICgx_mY9goMCxIJRkhSZXF1ZXN0GICAgIC5qZkKDA"
      expect(@request.numeric_status).to eq 1
      expect(@request.fancyhands_created_at).to eq DateTime.parse("2015-08-01T02:43:30.943430")
      expect(@request.fancyhands_updated_at).to eq DateTime.parse("2015-08-01T02:43:31.010720")
      expect(@request.responses.last).to eq response
    end

    it "puts the responses in order before save" do
      first_response = JSON.parse(File.read(File.expand_path("../../../fixtures/custom_requests/response.json", __FILE__)))
      last_response = first_response.dup
      last_response["date_updated"] = "2015-08-03T02:43:31.010720"
      subject.responses = [last_response, first_response]
      subject.run_callbacks(:save)
      expect(subject.responses.last).to eq last_response
    end

    it "converts the numeric_status into the correct status" do
      [
        [1, "NEW"],
        [5, "OPEN"],
        [7, "AWAITING_RESPONSE"],
        [20, "CLOSED"],
        [21, "EXPIRED"]
      ].each do |numeric_status, status|
        subject.numeric_status = numeric_status
        expect(subject.status).to eq status
      end
    end

    it "will not post to fancyhands if the key is already set" do
      subject.key = "ABCD"
      expect(subject.post_to_fancyhands).to eq nil
    end

    it "has a fancyhands_created_at attribute" do
      now = Time.now
      subject.fancyhands_created_at = now
      expect(subject.fancyhands_created_at).to eq now
    end

    it "has a fancyhands_updated_at attribute" do
      now = Time.now
      subject.fancyhands_updated_at = now
      expect(subject.fancyhands_updated_at).to eq now
    end

    # cancel the requests if they're created since they don't have a test system
    after do
      if @request.persisted? && @request.key.present?
        @request.cancel
      end
    end

  end
end
