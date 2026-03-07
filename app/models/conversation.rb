class Conversation < ApplicationRecord
  belongs_to :business
  has_many :messages, dependent: :destroy
end
