# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    name { Faker::Company.name }
    system_prompt do
      "You are a helpful customer support assistant. Be friendly, clear, and concise. " \
        "Answer questions about products and orders. If you don't know something, say so politely."
    end
  end
end
