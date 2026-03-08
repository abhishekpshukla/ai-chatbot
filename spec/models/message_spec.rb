# frozen_string_literal: true

require "rails_helper"

RSpec.describe Message, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_inclusion_of(:role).in_array(%w[user assistant]) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:conversation) }
  end

  describe "role" do
    it "accepts user" do
      message = build(:message, role: "user")
      expect(message).to be_valid
    end

    it "accepts assistant" do
      message = build(:message, :assistant)
      expect(message).to be_valid
    end

    it "rejects invalid role" do
      message = build(:message, role: "invalid")
      expect(message).not_to be_valid
      expect(message.errors[:role]).to be_present
    end
  end
end
