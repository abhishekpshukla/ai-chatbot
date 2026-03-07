# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
Business.find_or_create_by!(name: "Demo Store") do |b|
  b.system_prompt = <<~PROMPT.strip
    You are a helpful customer support assistant for Demo Store. Be friendly, clear, and concise.
    Answer questions about products, orders, and store policies. If you don't know something, say so and offer to help in another way.
  PROMPT
end
