# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChatService do
  let(:business) { create(:business, system_prompt: "You are a support bot.") }
  let(:conversation) { create(:conversation, business: business) }
  let(:user_message) { "Hello, I need help." }
  let(:stubbed_reply) { "Hello, how can I help?" }

  let(:openai_response_body) do
    {
      "choices" => [
        {
          "message" => {
            "content" => stubbed_reply,
            "role" => "assistant"
          }
        }
      ]
    }.to_json
  end

  before do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_return(status: 200, body: openai_response_body, headers: { "Content-Type" => "application/json" })
  end

  describe "#call" do
    subject(:service) { described_class.new(conversation: conversation, user_message: user_message) }

    it "saves a user message to the database" do
      expect { service.call }.to change(conversation.messages, :count).by(2)

      user_msg = conversation.messages.find_by(role: "user")
      expect(user_msg).to be_present
      expect(user_msg.content).to eq(user_message)
    end

    it "saves an assistant message to the database" do
      service.call

      assistant_msg = conversation.messages.find_by(role: "assistant")
      expect(assistant_msg).to be_present
      expect(assistant_msg.content).to eq(stubbed_reply)
    end

    it "returns the AI reply string" do
      expect(service.call).to eq(stubbed_reply)
    end

    it "sends the business system_prompt as the system message" do
      service.call

      expect(WebMock).to have_requested(:post, "https://api.openai.com/v1/chat/completions").with { |req|
        body = JSON.parse(req.body)
        messages = body["messages"]
        system_msg = messages.find { |m| m["role"] == "system" }
        system_msg && system_msg["content"] == "You are a support bot."
      }
    end
  end

  context "when OpenAI API returns an error" do
    before do
      stub_request(:post, "https://api.openai.com/v1/chat/completions")
        .to_return(status: 500, body: { "error" => { "message" => "Server error" } }.to_json)
    end

    it "raises and does not save the assistant message" do
      service = described_class.new(conversation: conversation, user_message: user_message)

      expect { service.call }.to raise_error(StandardError)
      expect(conversation.messages.where(role: "assistant")).to be_empty
    end
  end
end
