# frozen_string_literal: true

require "rails_helper"

RSpec.describe Conversation, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:session_id) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:business) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe "dependent destroy" do
    it "destroys associated messages when conversation is destroyed" do
      conversation = create(:conversation)
      create_list(:message, 2, conversation: conversation)

      expect { conversation.destroy }.to change(Message, :count).by(-2)
    end
  end
end
