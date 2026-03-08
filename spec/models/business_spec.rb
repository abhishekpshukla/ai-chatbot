# frozen_string_literal: true

require "rails_helper"

RSpec.describe Business, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:system_prompt) }
  end

  describe "associations" do
    it { is_expected.to have_many(:conversations).dependent(:destroy) }
  end

  describe "dependent destroy" do
    it "destroys associated conversations when business is destroyed" do
      business = create(:business)
      create_list(:conversation, 2, business: business)

      expect { business.destroy }.to change(Conversation, :count).by(-2)
    end
  end
end
