module TaskEngine
  RSpec.describe WebhookController do
    describe "POST #create" do
      before do
        @routes = Engine.routes
      end

      it "finds the related resource and adds the response to its responses" do
        fancyhands_response = JSON.parse(File.read(File.expand_path("../../../fixtures/custom_requests/response.json", __FILE__)))
        key = fancyhands_response["key"]
        custom_request = FactoryGirl.build(:task_engine_custom_request, key: key)
        expect(custom_request).to receive(:post_to_fancyhands)
        custom_request.save!

        request.env["HTTP_ACCEPT"] = "application/json"
        request.env['RAW_POST_DATA'] = fancyhands_response.to_json

        post :create
        expect(response.status).to eq 200

        custom_request.reload
        expect(custom_request.responses.last).to eq fancyhands_response
      end

      it "has a 400 status if the request body doesn't appear to be a fancy hands request" do
        request.env["HTTP_ACCEPT"] = "application/json"
        request.env["RAW_POST_DATA"] = { foo: "bar" }.to_json

        post :create

        expect(response.status).to eq 400
      end

      it "has a 400 status if the request body can't be parsed as json" do
        request.env["HTTP_ACCEPT"] = "application/json"
        request.env["RAW_POST_DATA"] = "this is not json"

        post :create

        expect(response.status).to eq 400
      end
    end
  end
end
