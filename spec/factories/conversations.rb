# frozen_string_literal: true

FactoryBot.define do
  factory :conversation do
    session_id { SecureRandom.hex(16) }
    association :business
  end
end
