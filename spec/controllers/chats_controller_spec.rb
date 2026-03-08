# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChatsController, type: :controller do
  let(:business) { create(:business) }

  before do
    allow(Business).to receive(:first).and_return(business)
  end

  describe "GET #index" do
    it "returns 200" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "assigns @business" do
      get :index
      expect(assigns(:business)).to eq(business)
    end
  end

  describe "POST #create" do
    let(:conversation) { create(:conversation, business: business) }
    let(:reply_text) { "Hello, how can I help?" }

    before do
      allow_any_instance_of(described_class).to receive(:session).and_return(double(id: conversation.session_id))
    end

    context "with valid params" do
      it "returns JSON with reply key" do
        allow_any_instance_of(ChatService).to receive(:call).and_return(reply_text)

        post :create, params: { business_id: business.id, message: "Hi" }, as: :json

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json["reply"]).to eq(reply_text)
      end
    end

    context "when ChatService raises an error" do
      it "returns unprocessable_entity with error JSON" do
        allow_any_instance_of(ChatService).to receive(:call).and_raise(StandardError.new("API error"))

        post :create, params: { business_id: business.id, message: "Hi" }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = response.parsed_body
        expect(json["error"]).to be_present
        expect(json["reply"]).to eq("")
      end
    end

    context "when business is not found" do
      it "returns not_found with error JSON" do
        post :create, params: { business_id: 99999, message: "Hi" }, as: :json

        expect(response).to have_http_status(:not_found)
        json = response.parsed_body
        expect(json["error"]).to eq("Business not found.")
      end
    end
  end
end
