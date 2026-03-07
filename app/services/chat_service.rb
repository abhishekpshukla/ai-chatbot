# frozen_string_literal: true

class ChatService
  def initialize(conversation:, user_message:)
    @conversation = conversation
    @user_message = user_message
  end

  def call
    save_user_message
    reply = fetch_ai_reply
    save_assistant_message(reply)
    reply
  end

  private

  attr_reader :conversation, :user_message

  def client
    @client ||= OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def messages_for_api
    system_message = { role: "system", content: conversation.business.system_prompt.to_s }
    history = conversation.messages.order(created_at: :asc).last(10).map do |msg|
      { role: msg.role, content: msg.content.to_s }
    end
    [system_message] + history
  end

  def save_user_message
    conversation.messages.create!(role: "user", content: user_message)
  end

  def fetch_ai_reply
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: messages_for_api,
        temperature: 0.7,
        max_tokens: 500
      }
    )
    response.dig("choices", 0, "message", "content").to_s.strip
  end

  def save_assistant_message(content)
    conversation.messages.create!(role: "assistant", content: content)
  end
end
