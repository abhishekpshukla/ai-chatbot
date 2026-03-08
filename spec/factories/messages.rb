# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    association :conversation
    role { "user" }
    content { Faker::Lorem.sentence }

    trait :assistant do
      role { "assistant" }
    end
  end
end
