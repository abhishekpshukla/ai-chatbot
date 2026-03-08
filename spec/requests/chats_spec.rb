# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Chats", type: :request do
  let(:business) { create(:business) }
  let(:browser_headers) do
    { "HTTP_USER_AGENT" => "Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0" }
  end

  before do
    allow(Business).to receive(:first).and_return(business)
  end

  around do |example|
    original = ENV["OPENAI_API_KEY"]
    ENV["OPENAI_API_KEY"] = "test-key"
    example.run
  ensure
    ENV["OPENAI_API_KEY"] = original
  end

  describe "GET /" do
    it "returns 200" do
      get root_path, headers: browser_headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /chat" do
    let(:openai_response_body) do
      {
        "choices" => [
          { "message" => { "content" => "Hello, how can I help?", "role" => "assistant" } }
        ]
      }.to_json
    end

    context "with valid params" do
      let(:conversation) { create(:conversation, business: business) }

      it "returns JSON with reply" do
        get root_path, headers: browser_headers
        conversations_relation = business.conversations
        allow(conversations_relation).to receive(:find_or_create_by!).with(session_id: anything).and_return(conversation)
        allow(business).to receive(:conversations).and_return(conversations_relation)
        allow(Business).to receive(:find).with(business.id.to_s).and_return(business)
        allow(Business).to receive(:find).with(business.id).and_return(business)
        chat_service_instance = double("ChatService", call: "Hello, how can I help?")
        allow(ChatService).to receive(:new).and_return(chat_service_instance)

        post "/chat",
          params: { business_id: business.id, message: "Hi" },
          as: :json,
          headers: browser_headers

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json["reply"]).to eq("Hello, how can I help?")
      end
    end

    context "with missing business" do
      it "returns 404" do
        post "/chat", params: { business_id: 99999, message: "Hi" }, as: :json, headers: browser_headers

        expect(response).to have_http_status(:not_found)
        json = response.parsed_body
        expect(json["error"]).to eq("Business not found.")
      end
    end

    context "when OpenAI API fails" do
      before do
        stub_request(:post, "https://api.openai.com/v1/chat/completions")
          .to_return(status: 500, body: { "error" => { "message" => "Server error" } }.to_json)
      end

      it "returns unprocessable_entity with error message" do
        get root_path, headers: browser_headers
        post "/chat", params: { business_id: business.id, message: "Hi" }, as: :json, headers: browser_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = response.parsed_body
        expect(json["error"]).to be_present
        expect(json["reply"]).to eq("")
      end
    end
  end
end
