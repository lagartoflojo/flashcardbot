class Card < ApplicationRecord
  belongs_to :deck
  belongs_to :front_side, class_name: 'CardSide', optional: true
  belongs_to :back_side, class_name: 'CardSide', optional: true

  scope :latest, -> { order(created_at: :desc) }
  scope :random, -> { order 'RANDOM()' }
end
