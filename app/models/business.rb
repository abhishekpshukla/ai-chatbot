class Business < ApplicationRecord
  has_many :conversations, dependent: :destroy

  validates :name, presence: true
  validates :system_prompt, presence: true
end
