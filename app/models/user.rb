class User < ApplicationRecord
  enum chat_status: [
    :waiting,
    :adding_deck,
    :adding_front_side,
    :adding_back_side,
    :choosing_deck_to_edit,
    :choosing_deck_to_practice,
    :showing_front_side,
    :showing_back_side
  ]

  validates :first_name, :telegram_id, presence: true

  has_many :decks
  belongs_to :current_deck, class_name: 'Deck', optional: true
  belongs_to :current_card, class_name: 'Card', optional: true
end
