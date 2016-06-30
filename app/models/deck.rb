class Deck < ApplicationRecord
  belongs_to :user
  has_many :cards

  scope :latest, -> { order(created_at: :desc) }
end
