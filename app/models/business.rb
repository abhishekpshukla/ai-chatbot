class Business < ApplicationRecord
  has_many :conversations, dependent: :destroy
end
